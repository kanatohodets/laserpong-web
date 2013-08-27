function test () {
    var a = new WebSocket('ws://localhost:3000/game');
    var b = new WebSocket('ws://localhost:3000/game');
    setInterval(function () {
        a.send('hi from a');
        b.send('hi from b');
    }, 2000);
}
