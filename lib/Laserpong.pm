package Laserpong;
use Mojo::Base 'Mojolicious';
use Mojo::Redis;
use Mojo::JSON;

use Laserpong::Game;
use Laserpong::Player;

# This method will run once at server start
sub startup {
    my $controller = shift;
    my $json = Mojo::JSON->new;

    my @games = ();
    my $players = {};
    my @waiting_players = ();

    # Router
    my $r = $controller->routes;

    # Normal route to controller
    $r->get('/')->to(cb => sub {
      my $self = shift;
      $self->render('game/index');
    });

    $r->websocket('/game')->to(cb => sub {
        my $websocket = shift;
        my $redis = Mojo::Redis->new(server => 'localhost:6379');
        say "hey hey got a new websocket connection";

        $redis->incr(player_id => sub {
            shift; #discard redis, already have it.
            my $new_player_id = shift;
            my $player = Laserpong::Player->new({id => $new_player_id, ws => $websocket, redis => $redis});
            $$players{$new_player_id} = $player;

            if (scalar @waiting_players > 0) {
                say "found a waiting player";
                $redis->incr(game_id => sub {
                    shift;
                    my $new_game_id = shift;

                    say "new game ID: $new_game_id";
                    #todo: use redis instead of local data structure
                    my $player_one = $player;
                    my $player_two = pop @waiting_players;

                    say "waiting player:  . " . $player_two->id . ". notifying about a game to play";
                    $redis->publish(waiting_players => $json->encode({'player_id' => $player_two->id, 'game_id' => $new_game_id}));
                    $player_one->start_game($new_game_id, 0);
                    $player_two->start_game($new_game_id, 1);
                    push @games, Laserpong::Game->new({players => [$player_one, $player_two], game_id => $new_game_id});

                    $player_one->on(exit => sub {
                        my $self = shift;
                        delete $$players{$self->id};
                        undef $player_one;
                        undef $websocket;
                        pop @games;
                        push @waiting_players, $player_two;
                        $player_two->wait;
                    });

                    $player_two->on(exit => sub {
                        my $self = shift;
                        delete $$players{$self->id};
                        undef $player_one;
                        undef $websocket;
                        pop @games;
                        push @waiting_players, $player_one;
                        $player_one->wait;
                    });
                });
            } else {
                # wait in the queue
                $player->wait;
                push @waiting_players, $player;
            }
        });
    });
}

1;
