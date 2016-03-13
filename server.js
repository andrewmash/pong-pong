var path = require('path');

var http = require('http');
var server = http.createServer();

var express = require('express');
var app = express();

var socketio = require('socket.io');

server.on('request', app);

// creates a new connection server for web sockets and integrates
// it into our HTTP server 
// this needs to be below the server.on('request', app) so that our 
// express app takes precedence over our socekt server for typical 
// HTTP requests 
var io = socketio(server);

var phones = {
  phone1: {},
  phone2: {}
};

// // use socket server as an event emitter in order to listen for new connctions
io.on('connection', function (socket) {
  //receives the newly connected socket
  //called for each browser that connects to our server
  console.log('A new client has connected');
  console.log('socket id: ', socket.id);

  //event that runs anytime a socket disconnects
  socket.on('disconnect', function () {
    console.log('socket id ' + socket.id + ' has disconnected. : (');
    if (phones.phone1.socket === socket.id) {
      console.log("They were phone1.");
      phones.phone1 = {};
    }
    if (phones.phone2.socket === socket.id) {
      console.log("They were phone2.");
      phones.phone2 = {};
    }
  });

  socket.on('phoneConnect', function () {
    var id;
    if (!phones.phone1.socket) {
      console.log("Assigning ", socket.id, " to phone1");
      phones.phone1.socket = socket.id;
      id = '1';
    } else if (!phones.phone2.socket) {
      console.log("Assigning ", socket.id, " to phone2");
      phones.phone2.socket = socket.id;
      id = '2';
    }
    socket.emit('phoneConnected', id);
  });

  socket.on('phoneReady', function(phone) {
    phones[phone].ready = true;
    if (phones.phone1.ready && phones.phone2.ready) {
      io.sockets.emit('phonesReady');
    }
  })

  socket.on('phone1', function (tilt) {
    socket.broadcast.emit('phone1Move', tilt);
  });

  socket.on('phone2', function (tilt) {
    socket.broadcast.emit('phone2Move', tilt);
  });

  socket.on('paddleMovement', function (player, yDirection) {
    if (player == 'player1') {
      io.sockets.emit('paddleMove1', yDirection);
    } else if (player == 'player2') {
      io.sockets.emit('paddleMove2', yDirection);
    }
  });
});

app.use(express.static(path.join(__dirname, 'browser')));

app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'index.html'));
});

server.listen(1337, function () {
  console.log('The server is listening on port 1337!');
});
