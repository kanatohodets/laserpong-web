package Laserpong::Game::Player;
use Mojo::Base 'Laserpong::Game::Entity';

use Laserpong::Game::Laser;

use constant minHeight => 2;
use constant hitPenalty => 0.5;
use constant laserMax => 8;
use constant healWait => 1;
use constant healAmount => 0.25;

use constant width => 1.35;
use constant startingHeight => 13.35;
use constant yVel => 66.67;

has name => 'Player';
has laserBank => 10;

#sig: Player->new(x, y, team);
sub new {
    my $class = shift;
    my $params = shift;
    $params->{moveQueue} = [];
    $params->{lasers} = [];
    $params->{yVel} = yVel;
    $params->{height} = startingHeight;
    $params->{width} = width;

    my $self = $class->SUPER::new($params);
    return $self;
}

sub update {
    my $self = shift;
    my $dt = shift;
    my $y = $self->y;
    if (scalar @{$self->{moveQueue}} > 0) {
        my $move = shift $self->{moveQueue};
        $y += $move * $self->yVel * $dt;
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

sub moveUp {
    my $self = shift;
    push $self->{moveQueue}, -1;
}

sub moveDown {
    my $self = shift;
    push $self->{moveQueue}, 1;
}

sub fireLaser {
    my $self = shift;
    $self->{laserBank}--;
    push $self->{lasers}, Laserpong::Game::Laser->new({x => $self->x, y => $self->y, team => $self->team});
}

1;
