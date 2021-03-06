use Mojo::Base -strict;

use Test::More;
use Laserpong::Game::Laser;

my $laser = Laserpong::Game::Laser->new({x => 100, y => 2, team => 1});

is $laser->x, 100;
is $laser->y, 2;
is $laser->team, 1;

my $old_x = $laser->x;
my $post_update = $old_x - $laser->x_vel;
$laser->update(1);
# team 1 goes 'left'
is $laser->x, $post_update;

done_testing();
