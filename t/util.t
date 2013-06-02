use Mojo::Base -strict;

use Test::More;
use Laserpong::Game::Laser;
use Laserpong::Game::Util qw(collide);

my $laserA = Laserpong::Game::Laser->new({x => 0, y => 2, team => 0});
my $laserB = Laserpong::Game::Laser->new({x => 56, y => 2, team => 1});

is (collide($laserA, $laserB), 0);

$laserB->update(1);
is (collide($laserA, $laserB), 1);

done_testing();
