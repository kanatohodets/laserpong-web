package Laserpong::Game::Util;
use Mojo::Base 'Exporter';

our @EXPORT_OK = qw(collide);

sub collide {
    my ($entity_a, $entity_b) = @_;
    my ($type_a, $type_b) = ($entity_a->bounding_shape, $entity_b->bounding_shape);

    return _circles_collide(@_) if $type_a eq $type_b and $type_b eq 'circle';
    return _rects_collide(@_);
}

sub _rects_collide {
    my ($a, $b) = @_;
    my ($left_a, $top_a, $width_a, $height_a) = ($a->left, $a->top, $a->width, $a->height);
    my ($left_b, $top_b, $width_b, $height_b) = ($b->left, $b->top, $b->width, $b->height);

    return 0 if $top_a > $top_b + $height_b;
    return 0 if $top_b > $top_a + $height_a;
    return 0 if $left_a > $left_b + $width_b;
    return 0 if $left_b > $left_a + $width_a;

    return 1;
}

sub _circles_collide {
    my ($a, $b) = @_;
    my ($x_a, $y_a, $radius_a) = ($a->x, $a->y, $a->radius);
    my ($x_b, $y_b, $radius_b) = ($b->x, $b->y, $b->radius);

    my $dist = sqrt((($x_a - $x_b) ** 2) + ($y_a - $y_b) ** 2);

    return 0 if $dist > $radius_a + $radius_b;

    return 1;
}

1;
