package Laserpong::Game::Util;
use Mojo::Base 'Exporter';

our @EXPORT_OK = qw(collide);

sub collide {
    my ($entityA, $entityB) = @_;
    my ($typeA, $typeB) = ($entityA->boundingShape, $entityB->boundingShape);

    return _circlesCollide(@_) if $typeA eq $typeB and $typeB eq 'circle';
    return _rectsCollide(@_);
}

sub _rectsCollide {
    my ($a, $b) = @_;
    my ($leftA, $topA, $wA, $hA) = ($a->left, $a->top, $a->width, $a->height);
    my ($leftB, $topB, $wB, $hB) = ($b->left, $b->top, $b->width, $b->height);

    return 0 if $topA > $topB + $hB;
    return 0 if $topB > $topA + $hA;
    return 0 if $leftA > $leftB + $wB;
    return 0 if $leftB > $leftA + $wA;

    return 1;
}

sub _circlesCollide {
    my ($a, $b) = @_;
    my ($xA, $yA, $rA) = ($a->x, $a->y, $a->radius);
    my ($xB, $yB, $rB) = ($b->x, $b->y, $b->radius);

    my $dist = sqrt((($xA - $xB) ** 2) + ($yA - $yB) ** 2);

    return 0 if $dist > $rA + $rB;

    return 1;
}

1;
