package Laserpong;
use Mojo::Base 'Mojolicious';
use Mojo::Redis;
use Mojo::JSON;
use Mojo::IOLoop;

use Laserpong::Game;

# This method will run once at server start
sub startup {
    my $controller = shift;
    my $json = Mojo::JSON->new;
    my $redis = Mojo::Redis->new(server => 'localhost:6379');

    my @games = ();
    my @waiting_players = ();

    # Router
    my $r = $controller->routes;

    # Normal route to controller
    $r->get('/')->to(cb => sub {
      my $self = shift;
      $self->render('game/index');
    });

    $r->websocket('/game')->to(cb => sub {
        my $self = shift;
        my $pub = Mojo::Redis->new;

        $self->app->log->debug('websocket hit to /game');
        $redis->incr(player_id => sub {
            my ($redis, $new_player_id) = @_;

            $self->app->log->debug("new player ID from redis: $new_player_id");
            $self->app->log->debug("waiting players: @waiting_players");

            if (scalar @waiting_players > 0) {

                $self->app->log->debug("waiting player found, creating new game");

                $redis->incr(game_id => sub {
                    my ($redis, $new_game_id) = @_;
                    my $waiting_player_id = pop @waiting_players;

                    $self->app->log->debug("ids: waiting: $waiting_player_id new: $new_player_id game: $new_game_id");

                    push @games, Laserpong::Game->new({player_ids => [$new_player_id, $waiting_player_id], game_id => $new_game_id});
                });
            } else {
                $self->app->log->debug("no waiting players for player #$new_player_id to play, get in the queue...");
                push @waiting_players, $new_player_id;
            }

            $self->on('message' => sub {
                my ($self, $message) = @_;
                $controller->websocket_dispatch($message);
            });
        });
    });
}

sub websocket_dispatch {
    my $self = shift;
    my $message = shift;
    my $json = Mojo::JSON->new;
    $self->app->log->debug("ws dispatch: " . $message);
}

1;
