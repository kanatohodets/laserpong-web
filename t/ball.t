use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Laserpong::Game::Ball;

my $t = Test::Mojo->new('Laserpong');
my $ball = Laserpong::Game::Ball->new(1, 2, 5, 5);

is $ball->x, 1;
is $ball->y, 2;
is $ball->xVel, 5;
is $ball->yVel, 5;
is $ball->radius, 1;
is $ball->height, 2;
is $ball->width, 2;

done_testing();
