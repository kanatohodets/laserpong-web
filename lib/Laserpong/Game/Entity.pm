package Laserpong::Game::Entity;
use Mojo::Base -base;

has name => 'Entity';
has boundingShape => 'rect';
has [qw(x y xVel yVel)] => 0;
has [qw(width height)] => 0;
has radius => 0;
has team => -1;

sub left {
    my $self = shift;
    return $self->x - $self->radius if $self->boundingShape eq 'circle';
    return $self->x - $self->width/2 if $self->boundingShape eq 'rect';
}

sub top {
    my $self = shift;
    return $self->y - $self->radius if $self->boundingShape eq 'circle';
    return $self->y - $self->height/2 if $self->boundingShape eq 'rect';
}

sub bottom {
    my $self = shift;
    return $self->y + $self->radius if $self->boundingShape eq 'circle';
    return $self->y + $self->height/2 if $self->boundingShape eq 'rect';
}

1;
