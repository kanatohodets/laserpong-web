var Laser = function (x, y, owner) {
    var self = new MovingEntity(x, y);
    self.xVel = (55.55 / 100);
    self.radius = (1.11 / 100);
    self.team = owner.team;
    self.alive = true;
    self.boundingShape = "circle";

    self.draw = function () {

    };

    self.update = function (dt) {
        if (self.team === 0) {
            self.x += self.xVel * dt;
            for (var laser in players[1].lasers) {
                if (self.collide(laser)) {
                    self.die();
                    laser.die();
                }
            }
        else if (self.team === 1) {
            self.x -= self.xVel * dt;
        }

        if ((self.x < -self.radius) || (self.x > Field.width + self.radius)) {
            self.die();
            return;
        }

        if (self.collide(ball)) {
            if (self.team === 0 && ball.xVel < 0) || (self.team === 1 && ball.xVal > 0) {
                self.hit(ball);
                ball.hitLaser(self);
            }
        }

        if (self.collide(players[0])) {
            self.hit(players[0]);
            players[1].hitByLaser(self);
        }

        if (self.collide(players[1])) {
            self.hit(players[1]);
            players[1].hitByLaser(self);
        }
    };

    self.hit = function (struckEntity) {
        if (struckEntity.team !== self.team) {
            self.die();
        }
    };

    self.die = function () {
        self.alive = false;
    };

    return self;
};
