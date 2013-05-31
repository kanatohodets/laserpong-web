use Mojo::Base -strict;

use Test::More;
use Laserpong::Game::Entity;
use Laserpong::Game::Util qw(collide);

my $entityA = Laserpong::Game::Entity->new(0, 0, 0, 0, 5, 5);
my $entityB = Laserpong::Game::Entity->new(3, 3, 5, 5, 5, 5);
is (collide($entityA, $entityB), 1);

$entityB->update(1);
$entityB->update(1);
is (collide($entityA, $entityB), 0);

done_testing();
