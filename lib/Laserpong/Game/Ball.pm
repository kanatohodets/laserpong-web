package Laserpong::Game::Ball;
use Mojo::Base 'Laserpong::Game::Entity';

use constant radius => 1;

has name => 'Ball';
has boundingShape => 'circle';
has yVelMax => sub {
    my $self = shift;
    return $self->yVel * 5;
};

#sig: Ball->new(x, y, xVel, yVel)
sub new {
    my $self = shift->SUPER::new(@_, radius, 'bogus');
    return $self;
}

1;
