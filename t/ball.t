use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Laserpong::Game::Ball;

my $t = Test::Mojo->new('Laserpong');
my $ball = Laserpong::Game::Ball->new({x => 1, y => 2, xVel => 5, yVel => 5});

is $ball->x, 1;
is $ball->y, 2;
is $ball->xVel, 5;
is $ball->yVel, 5;

done_testing();
