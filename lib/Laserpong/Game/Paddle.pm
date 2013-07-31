package Laserpong::Game::Paddle;
use Mojo::Base 'Laserpong::Game::Entity';
use Data::Dumper;
use Laserpong::Game::Laser;

use constant min_height => 2;
use constant hit_penalty => 0.5;
use constant laser_max => 8;
use constant heal_wait => 1;
use constant heal_amount => 0.25;

use constant width => 1.35;
use constant starting_height => 13.35;
use constant y_vel => 66.67;

has name => 'Paddle';
has laser_bank => 10;
has player_id => -1;

#sig: Paddle->new(team, player_id);
sub new {
    my $class = shift;
    my $params = shift;
    $params->{move_queue} = [];
    $params->{lasers} = [];
    $params->{y_vel} = y_vel;
    $params->{height} = starting_height;
    $params->{width} = width;

    my $self = $class->SUPER::new($params);
    return $self;
}

sub update {
    my $self = shift;
    my $dt = shift;
    my $frame = shift;
    my ($id, $x, $y) = ($self->player_id, $self->x, $self->y);
    print "frame: $frame player $id update: $x, $y\n";

    if (scalar @{$self->{move_queue}} > 0) {
        my $move = shift $self->{move_queue};
        $y += $move * $self->y_vel * $dt;
    }

    $self->y($y);
    # bounds checking
    if ($self->bottom > 100) {
        $self->y(100 - $self->height / 2);
    }

    if ($y < $self->height / 2) {
        $self->y($self->height / 2);
    }

    foreach my $laser (@{$self->{lasers}}) {
        $laser->update($dt);
    }
}

sub move_up {
    my $self = shift;
    push $self->{move_queue}, -1;
}

sub move_down {
    my $self = shift;
    push $self->{move_queue}, 1;
}

sub fire_laser {
    my $self = shift;
    $self->{laser_bank}--;
    push $self->{lasers}, Laserpong::Game::Laser->new({x => $self->x, y => $self->y, team => $self->team});
}

1;
