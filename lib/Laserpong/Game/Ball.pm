package Laserpong::Game::Ball;
use Mojo::Base 'Laserpong::Game::Entity';

has radius => 1;
has name => 'Ball';
has bounding_shape => 'circle';
has x_vel => 2;
has y_vel => 2;
has y_vel_max => sub {
    return shift->y_vel * 5;
};

has [qw(width height)] => sub {
    shift->radius * 2;
};

sub new {
    my $self = shift->SUPER::new(@_);
    # randomize starting direction
    $self->x_vel($self->x_vel * rand > 0.5 ? -1 : 1);
}

sub update {
    my $self = shift;
    my $dt = shift;
    my $frame = shift;
    my ($x, $y) = ($self->x, $self->y);
    print "frame $frame ball update: $x, $y\n";
    $self->x($self->x + $self->x_vel * $dt);
    $self->y($self->y + $self->y_vel * $dt);
}

1;
