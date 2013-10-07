package Laserpong::Game::Ball;
use Mojo::Base 'Laserpong::Game::Entity';

use constant X_VEL => 15;
use constant HIT_VELOCITY_INCREMENT => 1.5;
use constant COLLIDE_TIMEOUT => 10;

has radius => 1;
has name => 'Ball';
has bounding_shape => 'circle';
has x_vel => X_VEL;
has y_vel => 1;
has y_vel_max => sub {
    return shift->y_vel * 5;
};
has collide_timeout => 0;

has [qw(width height)] => sub {
    shift->radius * 2;
};

sub initialize {
    my $self = shift;
    # randomize starting direction
    $self->collide_timeout(0);
    $self->x(50);
    $self->y(50);
    $self->x_vel(X_VEL * (rand > 0.5 ? -1 : 1));
    $self->y_vel(0);

    print "ball init, with x of " . $self->x() . " and y of " . $self->y() . " and x_vel: " . $self->x_vel() . " yvel: " . $self->y_vel() . "\n";
}
sub new {
    my $self = shift->SUPER::new(@_);
    $self->initialize();
    return $self;
}

sub update {
    my $self = shift;
    my $dt = shift;
    my $frame = shift;
    my ($x, $y, $radius) = ($self->x, $self->y, $self->radius);
    my ($x_vel, $y_vel) = ($self->x_vel, $self->y_vel);
    my $collide_timeout = $self->collide_timeout;

    $collide_timeout-- if $collide_timeout > 0;
    $self->collide_timeout($collide_timeout);

    $x = $x + $x_vel * $dt;
    $y = $y + $y_vel * $dt;
    #print "frame $frame dt: $dt, ball vel: $x_vel, $y_vel, pos: $x, $y\n";

    #hit top or bottom wall
    if ($y < $radius || $y + $radius > 100) {
        print "WALL BOUNCE\n\n";
        $y = $y - $y_vel * $dt;
        $y_vel = -1 * $y_vel;
    }

    $self->y_vel($y_vel);
    $self->x($x);
    $self->y($y);

    #ball went out --> round is over
    if ($x < $radius) {
        print "ball went out the left!\n";
        $self->emit(score => 1);
    } elsif ($x + $radius > 100) {
        print "ball went out the right!\n";
        $self->emit(score => 0);
    }
}

sub hit_paddle {
    my $self = shift;
    my $struck_paddle_y = shift;
    my $frame = shift;

    my $collide_timeout = $self->collide_timeout;
    return if $collide_timeout > 0;
    $self->collide_timeout(COLLIDE_TIMEOUT);

    print "PADDLE bounce!\n\n";
    my $x = $self->x;
    my $y = $self->y;
    my $y_vel = $self->y_vel;
    my $x_vel = $self->x_vel;
    if ($y > 0) {
        if ($y > $struck_paddle_y) {
            $y_vel = $y_vel + HIT_VELOCITY_INCREMENT;
        } else {
            $y_vel = $y_vel - HIT_VELOCITY_INCREMENT;
        }
    } else {
        if ($y < $struck_paddle_y) {
            $y_vel = $y_vel - HIT_VELOCITY_INCREMENT;
        } else {
            $y_vel = $y_vel + HIT_VELOCITY_INCREMENT;
        }
    }

    if ($x_vel < 0) {
        $x_vel = -1 * X_VEL;
    } else {
        $x_vel = X_VEL;
    }
    $x_vel = -$x_vel;
    $self->x_vel($x_vel);
    $self->y_vel($x_vel);
}

1;
