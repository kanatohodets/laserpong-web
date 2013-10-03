package Laserpong::Game::Entity;
use Mojo::Base 'Mojo::EventEmitter';
use JSON::XS;

has name => 'Entity';
has bounding_shape => 'rect';
has [qw(x y x_vel y_vel)] => 0;
has [qw(width height)] => 0;
has radius => 0;
has team => -1;

sub left {
    my $self = shift;
    return $self->x - $self->radius if $self->bounding_shape eq 'circle';
    return $self->x - $self->width/2 if $self->bounding_shape eq 'rect';
}

sub top {
    my $self = shift;
    return $self->y - $self->radius if $self->bounding_shape eq 'circle';
    return $self->y - $self->height/2 if $self->bounding_shape eq 'rect';
}

sub bottom {
    my $self = shift;
    return $self->y + $self->radius if $self->bounding_shape eq 'circle';
    return $self->y + $self->height/2 if $self->bounding_shape eq 'rect';
}

sub guts {
    my $self = shift;
    return (
        x => $self->{x},
        y => $self->{y},
        x_vel => $self->{x_vel},
        y_vel => $self->{y_vel},
        width => $self->{width},
        height => $self->{height},
        team => $self->{team}
    );
}

sub TO_JSON {
    return shift->guts;
}

1;
