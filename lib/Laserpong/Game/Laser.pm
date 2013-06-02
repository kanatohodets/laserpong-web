package Laserpong::Game::Laser;
use Mojo::Base 'Laserpong::Game::Entity';

has name => 'Laser';
has boundingShape => 'circle';

has xVel => 55;
has radius => 1.11;

has [qw(width height)] => sub {
    shift->radius * 2;
};

sub update {
    my $self = shift;
    my $dt = shift;
    $self->x($self->x + $self->xVel * $dt) if $self->team == 0;
    $self->x($self->x - $self->xVel * $dt) if $self->team == 1;
}

1;
