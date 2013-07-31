package Laserpong::Game;
use Mojo::Base 'Mojo::EventEmitter';
use Mojo::IOLoop;
use Mojo::Redis;
use Data::Dumper;
use Laserpong::Game::Paddle;
use Laserpong::Game::Ball;

use constant maxScore => 11;

sub new {
    my $self = shift->SUPER::new(@_);
    my $params = shift;
    my $player_ids = $$params{player_ids};
    my $game_id = $$params{game_id};

    my $gameframe_event_id = undef;
    my $ball = Laserpong::Game::Ball->new();

    my @paddles = (Laserpong::Game::Paddle->new({team_id => 0, player_id => $$player_ids[0]}), 
                   Laserpong::Game::Paddle->new({team_id => 1, player_id => $$player_ids[1]}));

    my @entities = ($ball, @paddles);

    my $redis = Mojo::Redis->new(server => 'localhost:6379');

    $self->on('start_round', sub {
        my $gameframe = 0;
        $gameframe_event_id = Mojo::IOLoop->recurring(2.033 => sub {
            my $dt = 1;
            # perl is the bomb.
            map { $_->update($dt, $gameframe) } @entities;
            $gameframe++;
        });

        #end the round, reset the players/ball
        #count scores, end the game if needed.
        $ball->on('score', sub {
            my $self = shift;
            my ($score, $scoringPaddle) = (shift, shift);
            map { $_->reset() } @entities;
            Mojo::IOLoop->remove($gameframe_event_id);
            if ($score < maxScore) {
                Mojo::IOLoop->timer(5 => sub {
                    $self->emit('start');
                });
            } else {
                $self->emit('gameover', $scoringPaddle);
            }
        });
    });

    Mojo::IOLoop->timer(3 => sub { 
        $self->emit('start_round');
    });
}

1;
