window.onload = function () {
    var ws = new WebSocket('ws://localhost:3000/game');
    console.log('hello world!');
    console.log(ws);
    setInterval(function () {
        ws.send(JSON.stringify({action: 'hi from ' + teamID}));
    }, 2000);

    var canvas = document.getElementById('game');
    var ctx = canvas.getContext('2d');
    var width = canvas.width;
    var height = canvas.height;
    var teamID = null;
    var Ball = function () {
        var radius = 10;
        var self = {};
        self.guts = {
            x: 0.5 * width,
            y: 0.5 * height
        };
        self.draw = function () {
            ctx.fillRect(self.guts.x, self.guts.y, radius, radius);
        };

        self.update = function (myState) {
            self.guts.x = (myState.x / 100) * width;
            self.guts.y = (myState.y / 100) * height;
        };
        return self;
    };

    var Paddle = function (x, y) {
        var self = {};
        self.width = (1.35 / 100) * width;
        self.height = (2 / 100) * height;
        self.guts = {
            x: x,
            y: y
        };

        self.draw = function () {
            ctx.fillRect(self.guts.x, self.guts.y, self.guts.x - self.width / 2, self.guts.y + self.height / 2);
        };

        self.update = function (myState) {
            self.guts.x = (myState.x / 100) * width;
            self.guts.y = (myState.y / 100) * width;
        };

        return self;
    };

    var paddle0 = new Paddle(100, 100);
    var paddle1 = new Paddle(300, 300);

    var ball = Ball();

    window.onkeyup = function (e) {
        var key = e.keyCode;
        if (teamID) {
            if (key == 87) {
                console.log('sending move up');
                ws.send(JSON.stringify({action: 'move_up'}));
            }
            if (key == 83) {
                console.log('sending move down');
                ws.send(JSON.stringify({action: 'move_down'}));
            }
        }
    };

    ws.onmessage = function (e) {
        var msg = JSON.parse(e.data);
        if (msg['start']) {
            teamID = msg['start']['teamID'];
        } else {
            var gamestate = JSON.parse(e.data);
            paddle0.update(gamestate['paddle0']);
            paddle1.update(gamestate['paddle1']);
            ball.update(gamestate['ball']);
        }
    };

    window.test = function () {
        var a = new WebSocket('ws://localhost:3000/game');
        var b = new WebSocket('ws://localhost:3000/game');
        setInterval(function () {
            a.send('hi from a');
            b.send('hi from b');
        }, 2000);
        a.onmessage = function (e) {
            var msg = JSON.parse(e.data);
            if (msg['start']) {
                teamID = msg['start']['teamID'];
            } else {
                var gamestate = JSON.parse(e.data);
                paddle0.update(gamestate['paddle0']);
                paddle1.update(gamestate['paddle1']);
                ball.update(gamestate['ball']);
            }
        };

        b.onmessage = function (e) {
            //console.log('message to b', e.data);
        };
    }

    var frame = function () {
        ctx.clearRect(0, 0, width, height);
        ball.draw();
        paddle0.draw();
        paddle1.draw();
        window.requestAnimationFrame(frame);
    };

    window.requestAnimationFrame(frame);
};
