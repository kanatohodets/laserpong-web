use Mojo::Base -strict;

use Test::More;
use Laserpong::Game::Paddle;
use Laserpong::Game::Ball;

my $paddle = Laserpong::Game::Paddle->new({team => 1, player_id => 4});
my $ball = Laserpong::Game::Ball->new;

# Initial values
is $paddle->x, 90;
is $paddle->y, 50;
is $paddle->x_vel, 0;
is $paddle->y_vel, 66.67;
is $paddle->width, 1.35;
is $paddle->height, 2;
is $paddle->player_id, 4;

# Update without moving, make sure position doesn't change.
my $start_y = $paddle->y;
$paddle->update(0.01, 2, $ball);
is $paddle->x, 90;
is $paddle->y, $start_y;

# Move up (y goes down), check for correct position.
my $new_y = $paddle->y - $paddle->y_vel * 0.01;
$paddle->move_up();
$paddle->update(0.01, 2, $ball);
is $paddle->x, 90;
is $paddle->y, $new_y;

# Move down (y goes up), check for correct position.
$paddle->move_down();
$paddle->update(0.01, 3, $ball);
is $paddle->y, $start_y;

# Fire a laser, make sure the bank is now lower.
$paddle->fire_laser();
my $lasers = $paddle->lasers;
is scalar @$lasers, 1;

# Try to move off the map (note the delta time given to update)
# Should lock paddle->y to height / 2
$paddle->move_up();
$paddle->update(1, 4, $ball);
my $half_height = $paddle->height / 2;
is $paddle->y, $half_height;

# Try to move off the map in the other direction 
# (off the bottom, which means y > 100)
my $max_y = 100 - $paddle->height / 2;
$paddle->move_down();
$paddle->update(1, 5, $ball);
$paddle->move_down();
$paddle->update(1, 6, $ball);
is $paddle->y, $max_y;

done_testing();
