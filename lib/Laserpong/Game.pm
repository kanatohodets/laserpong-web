package Laserpong::Game;
use Mojo::Base -base;
use Laserpong::Game::Player;
use Laserpong::Game::Ball;

use constant maxScore => 11;

sub new {
    my $self = shift->SUPER::new(@_);

    return $self;
}

sub start {

}

sub end {

}

sub reset {

}


1;
