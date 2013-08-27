use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Laserpong::Game::Ball;

my $t = Test::Mojo->new('Laserpong');
my $ball = Laserpong::Game::Ball->new;

#placeholder
is 1, 1;

done_testing();
