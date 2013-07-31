use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Laserpong::Game::Entity;

my $t = Test::Mojo->new('Laserpong');
my $entity = Laserpong::Game::Entity->new({x => 1, y => 2});

is $entity->x, 1;
is $entity->y, 2;
is $entity->team, -1;

#configure the entity like a subclass would.
$entity->x_vel(5);
$entity->y_vel(3);
$entity->width(10);
$entity->height(6);

is $entity->x_vel, 5;
is $entity->y_vel, 3;
is $entity->width, 10;
is $entity->height, 6;
is $entity->bounding_shape, 'rect';

is $entity->left, -4;
is $entity->top, -1;
is $entity->bottom, 5;

done_testing();
