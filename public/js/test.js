function test () {
    var a = new WebSocket('ws://localhost:3000/game');
    var b = new WebSocket('ws://localhost:3000/game');
    setInterval(function () {
        a.send('hi from a');
        b.send('hi from b');
    }, 2000);
    a.onmessage = function (e) {
        console.log('message to a', e.data);
    };

    b.onmessage = function (e) {
        console.log('message to b', e.data);
    };
}
