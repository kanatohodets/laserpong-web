use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Laserpong::Game::Ball;

my $t = Test::Mojo->new('Laserpong');
my $ball = Laserpong::Game::Ball->new({x => 1, y => 2, x_vel => 5, y_vel => 5});

is $ball->x, 1;
is $ball->y, 2;
is $ball->x_vel, 5;
is $ball->y_vel, 5;

done_testing();
