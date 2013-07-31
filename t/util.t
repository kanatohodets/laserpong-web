use Mojo::Base -strict;

use Test::More;
use Laserpong::Game::Laser;
use Laserpong::Game::Util qw(collide);

my $laser_a = Laserpong::Game::Laser->new({x => 0, y => 2, team => 0});
my $laser_b = Laserpong::Game::Laser->new({x => 56, y => 2, team => 1});

is (collide($laser_a, $laser_b), 0);

$laser_b->update(1);
is (collide($laser_a, $laser_b), 1);

done_testing();
