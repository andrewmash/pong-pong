


// we need this socket object to send messages to our server 
var socket = io(window.location.origin); 

socket.on('connect', function(){

  console.log('I have made a persistent two-way connection to the server!'); 
  

  // the draw event is emitted in whiteboard.js and caught here
  whiteboard.on('draw', function toBeRunOnlyOnDraw(start, end, color){
      socket.emit('imDrawing', start, end, color)
  })

  socket.on('otherDraw', function(start, end, color){
    whiteboard.draw(start, end, color)
  })
  
})


// ////rooms: 
// var socket = io(location.origin);

// socket.on('connect', function () {

//     var room = 'room';

//     socket.emit('wantToJoinRoomPlox', room);

//     whiteboard.on('draw', function (start, end, color) {
//         socket.emit('newDraw', start, end, color);
//     });



//     socket.on('drawHistory', function (drawHistory) {
//         drawHistory.forEach(function (draw) {
//             whiteboard.draw(draw.start, draw.end, draw.color);
//         });
//     });

//     socket.on('someoneElseDrew', function (start, end, color) {
//         whiteboard.draw(start, end, color);
//     });

// });
