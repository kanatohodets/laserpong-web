var MovingEntity = function (x, y) {
    var self = {};

    self.x = x;
    self.y = y;

    var rectsCollide = function (entityA, entityB) {
        var leftA = entityA.left(), 
            topA = entityA.top(),
            wA = entityA.width,
            hA = entityA.height;
        var leftB = entityB.left();
            topB = entityB.top();
            wB = entityB.width;
            hB = entityB.height;

        if (topA > topB + hB) {
            return false;
        } else if (topB > topA + hA) {
            return false;
        } else if (leftA > leftB + wB) {
            return false;
        } else if (leftB > leftA + wA) {
            return false;
        }
        return true;
    };

    var circsCollide = function (entityA, entityB) {
        var xA = entityA.x,
            yA = entityA.y,
            rA = entityA.radius;

        var xB = entityB.x,
            yB = entityB.y,
            rB = entityB.radius;

        var dist = Math.sqrt(Math.pow((xA - xB), 2) + Math.pow((yA - yB), 2));

        if (dist < rA + rB) {
            return true;
        }

        return false;
    };

    self.collide = function (entity) {
        var type = entity.boundingShape;

        if (self.boundingShape === 'circle' && type === 'circle') {
            return circsCollide(self, entity);
        } else {
            return rectsCollide(self, entity);
        }
    };


    return self;
};
