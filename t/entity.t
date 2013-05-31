use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Laserpong::Game::Entity;

my $t = Test::Mojo->new('Laserpong');
my $entity = Laserpong::Game::Entity->new(1, 2, 5, 3, 10, 6);

is $entity->x, 1;
is $entity->y, 2;
is $entity->xVel, 5;
is $entity->yVel, 3;
is $entity->width, 10;
is $entity->height, 6;
is $entity->boundingShape, 'rect';

is $entity->left, -4;
is $entity->top, -1;
is $entity->bottom, 5;

# Run one frame of update.
$entity->update(1);
is $entity->x, 6;
is $entity->y, 5;

is $entity->left, 1;
is $entity->top, 2;
is $entity->bottom, 8;


done_testing();
