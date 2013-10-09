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
    var playerID = null;
    var Ball = function () {
        var radius = (1 / 100) * height;
        var self = {};
        self.guts = {
            x: 0.5 * width,
            y: 0.5 * height,
            xVel: 0,
            yVel: 0
        };
        self.draw = function () {
            //self.guts.x = self.guts.x + self.guts.xVel;
            //self.guts.y = self.guts.y + self.guts.yVel;
            ctx.fillRect(self.guts.x, self.guts.y, radius, radius);
        };

        self.update = function (myState) {
            self.guts.x = (myState.x / 100) * width;
            self.guts.y = (myState.y / 100) * height;
            self.guts.xVel = (myState.xVel / 100) * width;
            self.guts.yVel = (myState.yVel / 100) * height;
        };
        return self;
    };

    var Paddle = function (x, y) {
        var self = {};
        var yVel = (40 / 100) * height;
        self.width = (1.35 / 100) * width;
        self.height = (13 / 100) * height;
        self.guts = {
            x: x,
            y: y
        };

        self.moveUp = function () {
            self.y += yVel;
        };

        self.moveDown = function () {
            self.y -= yVel;
        };

        self.draw = function () {
            ctx.fillRect(self.guts.x - self.width / 2, self.guts.y - self.height / 2, self.width, self.height);
        };

        self.update = function (myState) {
            //self.width = (myState.width / 100) * width;
            //self.height = (myState.height / 100) * height;
            self.guts.x = (myState.x / 100) * width;
            self.guts.y = (myState.y / 100) * width;
        };

        return self;
    };

    var paddle0 = new Paddle(0.1 * width, 0.5 * height);
    var paddle1 = new Paddle(0.9 * width, 0.5 * height);
    var paddles = [paddle0, paddle1];

    var ball = Ball();

    window.onkeydown = function (e) {
        console.log('I am player ' + playerID, 'which is teamID ' + teamID);
        var key = e.keyCode;
        if (teamID != undefined) {
            if (key == 87) {
                console.log('sending move up');
                paddles[teamID].moveUp();
                ws.send(JSON.stringify({action: 'move_up'}));
            }
            if (key == 83) {
                console.log('sending move down');
                paddles[teamID].moveDown();
                ws.send(JSON.stringify({action: 'move_down'}));
            }
        }
    };

    ws.onmessage = function (e) {
        var msg = JSON.parse(e.data);
        if (msg['start']) {
            teamID = msg['start']['teamID'];
            playerID = msg['start']['playerID'];
        } else {
            var gamestate = JSON.parse(e.data);
            //console.log(gamestate['paddle0']);
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
