package Laserpong::Game::Ball;
use Mojo::Base 'Laserpong::Game::Entity';

has radius => 1;
has name => 'Ball';
has boundingShape => 'circle';
has yVelMax => sub {
    return shift->yVel * 5;
};

has [qw(width height)] => sub {
    shift->radius * 2;
};

sub update {
    my $self = shift;
    my $dt = shift;
    $self->x($self->x + $self->xVel * $dt);
    $self->y($self->y + $self->yVel * $dt);
}

1;
