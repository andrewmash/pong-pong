// we need this socket object to send messages to our server 

window.pongBoard = new window.EventEmitter();

var socket = io(window.location.origin);

var velocity1 =

  socket.on('connect', function () {

    console.log('I have made a persistent two-way connection to the server!');

    // the draw event is emitted in whiteboard.js and caught here
    pongBoard.on('move', function playerMovement(player, direction) {
      socket.emit('paddleMovement', player, direction);
    })

    socket.on('phoneMove', function (tilt) {
      pongBoard.emit('move1', tilt);
    });

    // Event listener for sliding

    // socket.on('phoneMove', function (yAcceleration) {
    //   pongBoard.emit('move1', yAcceleration);
    // });

    // socket.on('paddleMove1', function(direction){
    //   pongBoard.emit('move1', direction);
    // })

    // socket.on('paddleMove2', function(direction){
    //   pongBoard.emit('move2', 'direction');
    // })

  })

window.addEventListener('deviceorientation', function (event) {
  socket.emit('phone', event.beta);
});

//event.acceleration.y => long axis acceleration
//
// window.ondevicemotion = function (event) {
//   socket.emit('phone', event.acceleration.y);
// }
