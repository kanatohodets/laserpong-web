package Laserpong::Game;
use Mojo::Base 'Mojo::EventEmitter';
use JSON::XS;
use Mojo::IOLoop;
use Data::Dumper;
use Laserpong::Game::Paddle;
use Laserpong::Game::Ball;

use constant MAX_SCORE => 11;

has players => undef;
has game_id => undef;
has ball => undef;
has paddles => undef;

sub new {
    my $game = shift->SUPER::new(@_);
    my $params = shift;
    my $json = JSON::XS->new->utf8->allow_blessed(1)->convert_blessed(1);

    my $ball = Laserpong::Game::Ball->new();
    $game->ball($ball);

    my $paddle1 = Laserpong::Game::Paddle->new({
        game => $game,
        team => 0,
        player_id => $game->players->[0]->id
    });

    my $paddle2 = Laserpong::Game::Paddle->new({
        game => $game,
        team => 1,
        player_id => $game->players->[1]->id
    });

    my @paddles = ($paddle1, $paddle2);
    my @scores = (0, 0);

    $game->paddles(\@paddles);
    my @entities = (@paddles, $ball);

    $game->on('start_round', sub {
        my $game = shift;
        say "round starting!...";
        my $gameframe = 0;
        map {
            my $id = $_->id;
            $_->on('laser', sub {
                say $id . " fires a laser!";
            });
            $_->on('move_up', sub {
                say $id . " moves down!";
            });
            $_->on('move_down', sub {
                say $id . " moves down!";
            });
        } @{$game->players};

        my $gameframe_event_id = Mojo::IOLoop->recurring(0.033 => sub {
            my $dt = 1;
            # perl is the bomb.
            $_->update($dt, $gameframe, $ball) for @entities;

            #TODO: link the player events with paddle actions. also
            #websockets->events
            $gameframe++;
            my $gamestate = {
                gameframe => $gameframe,
                player1 => $paddles[0],
                player2 => $paddles[1],
                ball => $ball
            };
            $gamestate = $json->encode($gamestate);
            $_->emit('update', $gamestate) for @{$game->players};

        });
        say "my gameframe_event_id is $gameframe_event_id";
        sleep 5;

        #end the round, reset the players/ball
        #count scores, end the game if needed.
        $ball->once('score', sub {
            print "a score! the score is: ";
            my $self = shift;
            my $scoringTeam = shift;
            my $score = ++$scores[$scoringTeam];
            say "@scores";
            Mojo::IOLoop->remove($gameframe_event_id);

            $_->initialize() for @entities;

            map {
                $_->unsubscribe('laser');
                $_->unsubscribe('move_down');
                $_->unsubscribe('move_up');
            } @{$game->players};

            if ($score < MAX_SCORE) {
                say "new round in 5 seconds ... ";
                Mojo::IOLoop->timer(5 => sub {
                    $game->emit('start_round');
                });
            } else {
                say "team $scoringTeam won!";
                $game->emit('gameover', $scoringTeam);
            }
        });
    });

    Mojo::IOLoop->timer(3 => sub {
        $game->emit('start_round');
    });
}

1;
