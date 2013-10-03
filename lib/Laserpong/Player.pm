package Laserpong::Player;
use Mojo::Redis;
use JSON::XS;
use Mojo::Base 'Mojo::EventEmitter';
use Data::Dumper qw(Dumper);

has id => -1;
has ws => sub { \1 };
has sub => sub { \1 };

has redis => sub { \1 };

sub new {
    my $self = shift->SUPER::new(@_);
    $self->on('update', sub {
        my $self = shift;
    });

    return $self;
}

sub start_game {
    my ($self, $game_id) = @_;
    $self->_bind($game_id);
}

sub wait {
    my $self = shift;

    $self->ws->send("wait in the queue, player #" . $self->id);
    $self->sub($self->redis->subscribe('waiting_players'));
    my $cb;
    $cb = $self->sub->on(message => sub {
        my ($sub, $msg, $channel) = @_;
        $msg = decode_json $msg;
        my ($player_id, $game_id) = @$msg{'player_id', 'game_id'};

        if (int $player_id == $self->id) {
            $sub->unsubscribe($cb);
            say "$player_id unsubscribed from waiting_players and subscribed to game # $game_id.";
        }
    });
}

sub _bind {
    my $self = shift;
    my $game_id = shift;
    my $ws = $self->ws;
    my $id = $self->id;
    my $redis = $self->redis;

    my $channel = "game:$game_id";

    my $game_subscription = $redis->psubscribe("$channel*");
    $self->sub($game_subscription);

    $game_subscription->on(message => sub {
        shift;
        my ($msg, $channel) = (shift, shift);
        my @channel_details  = split ':', $channel;
        my $source_player = $channel_details[2];
        $ws->send($msg) if $source_player != $id;
    });

    $ws->on(message => sub {
        shift;
        my $msg = shift;
        $self->ws_dispatch($msg);
        $redis->publish("$channel:$id" => $msg);
    });

    $self->on(update => sub {
        shift;
        say "sending an update to player $id!";
        my $json_gamestate = shift;
        $ws->send($json_gamestate);
    });
}

sub ws_dispatch {
    my ($self, $msg) = @_;
    #$msg = decode_json $msg;
    $self->emit('laser');
    $self->emit('move_up');
    $self->emit('move_down');
}

1;
