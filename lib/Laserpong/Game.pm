package Laserpong::Game;
use Mojo::Base 'Mojo::EventEmitter';
use Mojo::IOLoop;
use Mojo::Redis;
use Data::Dumper;
use Laserpong::Game::Paddle;
use Laserpong::Game::Ball;

use constant MAX_SCORE => 11;

has player_ids => undef;
has game_id => undef;
has ball => undef;
has paddles => undef;

sub new {
    my $self = shift->SUPER::new(@_);
    my $params = shift;

    my $ball = Laserpong::Game::Ball->new();
    $self->ball($ball);

    my $player1 = Laserpong::Game::Paddle->new({
        game => $self,
        team => 0,
        player_id => $self->player_ids->[0]
    });

    my $player2 = Laserpong::Game::Paddle->new({
        game => $self,
        team => 1,
        player_id => $self->player_ids->[1]
    });

    my @paddles = ($player1, $player2);
    my @scores = (0, 0);

    $self->paddles(\@paddles);
    my @entities = (@paddles, $ball);

    $self->on('start_round', sub {
        my $game = shift;
        print "round starting!...\n";
        my $gameframe = 0;
        my $gameframe_event_id = Mojo::IOLoop->recurring(0.033 => sub {
            my $dt = 1;
            # perl is the bomb.
            map { $_->update($dt, $gameframe, $ball) } @entities;
            $gameframe++;
        });
        print "my gameframe_event_id is $gameframe_event_id\n";
        sleep 5;

        #end the round, reset the players/ball
        #count scores, end the game if needed.
        $ball->once('score', sub {
            print "a score! the score is: ";
            my $self = shift;
            my $scoringTeam = shift;
            my $score = ++$scores[$scoringTeam];
            print "@scores\n";
            Mojo::IOLoop->remove($gameframe_event_id);
            map { $_->initialize() } @entities;
            if ($score < MAX_SCORE) {
                print "new round in 5 seconds ... \n";
                Mojo::IOLoop->timer(5 => sub {
                    $game->emit('start_round');
                });
            } else {
                print "team $scoringTeam won!\n";
                $game->emit('gameover', $scoringTeam);
            }
        });
    });

    Mojo::IOLoop->timer(3 => sub { 
        $self->emit('start_round');
    });
}

1;
