package Laserpong::Game::Entity;
use Mojo::Base -base;

has name => 'Entity';
has boundingShape => 'rect';
has [qw(x y xVel yVel)] => 0;
has [qw(width height)] => 0;
has radius => 0;

sub new {
    my $self = shift->SUPER::new(@_);
    $self->x(shift);
    $self->y(shift);
    $self->xVel(shift);
    $self->yVel(shift);

    if ($self->boundingShape eq 'rect') {
        $self->width(shift);
        $self->height(shift);
    } elsif ($self->boundingShape eq 'circle') {
        $self->radius(shift);
        # circles get rect dimensions so they can be fed through the
        # collideRect function seamlessly.
        $self->width($self->radius * 2);
        $self->height($self->radius * 2);
    }
    return $self;
}

sub update {
    my $self = shift;
    my $dt = shift;
    $self->x($self->x + $self->xVel * $dt);
    $self->y($self->y + $self->yVel * $dt);
}

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
