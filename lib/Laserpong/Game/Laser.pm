package Laserpong::Game::Laser;
use Mojo::Base 'Laserpong::Game::Entity';

use constant xVel => 55;
use constant radius => 1.11;

has name => 'Laser';
has boundingShape => 'circle';

#sig: Laser->new(X, Y)
sub new {
    # because this one has fewer elements than the base class, need to stick
    # a bogus value on the end
    my $self = shift->SUPER::new(@_, xVel, 0, radius, 'bogus');
    return $self;
}

1;
