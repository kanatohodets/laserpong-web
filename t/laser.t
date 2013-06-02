use Mojo::Base -strict;

use Test::More;
use Laserpong::Game::Laser;

my $laser = Laserpong::Game::Laser->new({x => 1, y => 2, team => 1});

is $laser->x, 1;
is $laser->y, 2;
is $laser->team, 1;
is $laser->xVel, 55;
is $laser->yVel, 0;
is $laser->radius, 1.11;
is $laser->width, 2.22;
is $laser->height, 2.22;

done_testing();
