package Laserpong::Game::Paddle;
use Mojo::Base 'Laserpong::Game::Entity';
use JSON::XS;
use Data::Dumper;
use Laserpong::Game::Laser;
use Laserpong::Game::Util qw(collide);

use constant MIN_HEIGHT => 2;
use constant HIT_PENALTY => 0.5;
use constant LASER_MAX => 8;
use constant HEAL_WAIT => 1;
use constant HEAL_AMOUNT => 0.25;

use constant WIDTH => 1.35;
use constant STARTING_HEIGHT => 2; #13.35;
use constant Y_VEL => 66.67;

has name => 'Paddle';
has move_queue => sub { [] };
has lasers => sub { [] };
has y_vel => Y_VEL;
has height => STARTING_HEIGHT;
has width => WIDTH;
has player_id => -1;

sub initialize {
    my $self = shift;
    $self->move_queue([]);
    $self->lasers([]);
    $self->y_vel(Y_VEL);
    $self->height(STARTING_HEIGHT);
    $self->width(WIDTH);

    if ($self->team == 0) {
        $self->x(10);
    } else {
        $self->x(90);
    }
    $self->y(50);
    print $self->player_id . " init, with x of " . $self->x . " and y of " . $self->y . "\n";
}

#sig: Paddle->new(team, player_id);
sub new {
    my $self = shift->SUPER::new(@_);
    $self->initialize();
    return $self;
}

sub update {
    my ($self, $dt, $frame, $ball) = @_;
    my ($id, $x, $y) = ($self->player_id, $self->x, $self->y);

    print "frame: $frame player $id update: $x, $y\n";

    my $move_queue = $self->move_queue;
    if (scalar @$move_queue > 0) {
        my $move = shift $move_queue;
        $y += $move * $self->y_vel * $dt;
    }

    $self->y($y);
    # bounds checking
    if ($self->bottom > 100) {
        $self->y(100 - $self->height / 2);
    }

    if ($y < $self->height / 2) {
        $self->y($self->height / 2);
    }

    if (collide($self, $ball)) {
        $ball->hit_paddle($self->y);
    }

    foreach my $laser (@{$self->lasers}) {
        $laser->update($dt);
    }
}

sub move_up {
    my $self = shift;
    push @{$self->move_queue}, -1;
}

sub move_down {
    my $self = shift;
    push @{$self->move_queue}, 1;
}

sub fire_laser {
    my $self = shift;
    my $lasers = $self->lasers;
    if (scalar @$lasers < LASER_MAX) {
        push $lasers, Laserpong::Game::Laser->new({x => $self->x, y => $self->y, team => $self->team});
    }
}

sub TO_JSON {
    my $self = shift;
    my $lasers = $self->lasers;
    my %lasers = map {$_ => $$lasers[$_]->guts} 0 .. $#$lasers;
    my $json = {
        $self->guts,
        'lasers' => \%lasers
    };
    return $json;
}

1;
