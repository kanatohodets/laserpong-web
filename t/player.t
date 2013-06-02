use Mojo::Base -strict;

use Test::More;
use Laserpong::Game::Player;

my $player = Laserpong::Game::Player->new({x => 1, y => 50.6667, team => 1});

# Initial values
is $player->x, 1;
is $player->y, 50.6667;
is $player->xVel, 0;
is $player->yVel, 66.67;
is $player->width, 1.35;
is $player->height, 13.35;
is $player->laserBank, 10;

# Update without moving, make sure position doesn't change.
$player->update(0.01);

is $player->x, 1;
is $player->y, 50.6667;

# Move up (y goes down), check for correct position.
$player->moveUp();
$player->update(0.01);
is $player->x, 1;
is $player->y, 50;

# Move down (y goes up), check for correct position.
$player->moveDown();
$player->update(0.01);
is $player->y, 50.6667;

# Fire a laser, make sure the bank is now lower.
$player->fireLaser();
is $player->laserBank, 9;

# Try to move off the map (note the delta time given to update)
# Should lock player->y to height / 2
$player->moveUp();
$player->update(1);
is $player->y, 6.675;

# Try to move off the map in the other direction 
# (off the bottom, which means y > 100)
$player->moveDown();
$player->update(1);
$player->moveDown();
$player->update(1);
is $player->y, 93.325;

done_testing();
