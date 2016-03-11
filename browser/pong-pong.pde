float w = document.documentElement.clientWidth;
float h = document.documentElement.clientHeight;
float border = 10;
float ballX = 20;
float ballY = 60;
float ballR = 10;
float dX = random(1, 2);
float dY = random(1, 2);
float paddle1X;
float paddle1Y = (h-2*border)/2;
float paddle2X;
float paddle2Y = 10;
float paddleW = 10;
float paddleH = h/10;
float dPaddle = paddleH;
float boardWidth = 1;
float velocity1 = 0;
float velocity2 = 0;
float easing = 0.05;


void setup() {
	size(w-border, h-border);
	paddle1X = width-15;
	paddle2X = 0;
}

void draw() {  
	background(255, 255, 255);
	ellipse(ballX, ballY, 2 * ballR, 2 * ballR);
	rect(paddle1X, paddle1Y, paddleW, paddleH);
	rect(paddle2X, paddle2Y, paddleW, paddleH);


	// if (ballRight() > width || ballLeft() < 0) {
	// 	fill(255, 0, 0, 100);
	// 	rect(0, 0, width, height);
	// 	noLoop();
	// }

	if (collision()) {
		dX = -1.1 * dX;
	}

	if (ballBottom() > height || ballTop() < 0) {
		dY = -dY;
	}

	ballX = ballX + dX;
	ballY = ballY + dY;
}



boolean collision() {
	boolean returnValue = false;
	if ((ballRight() >= paddle1X) && (ballLeft() <= paddle1X)) {
		if ((ballBottom() >= paddle1Y) && (ballTop() <= paddle1Y + paddleH)) {
			returnValue = true;
		}
	}
	if ((ballLeft() <= paddle2X+paddleW) && (ballRight() >= paddle2X+paddleW)) {
		if ((ballBottom() >= paddle2Y) && (ballTop() <= paddle2Y + paddleH)) {
			returnValue = true;
		}
	}
	return returnValue;
}

float ballLeft() {
	return ballX - ballR;
}

float ballRight() {
	return ballX + ballR;
}

float ballTop() {
	return ballY - ballR;
}

float ballBottom() {
	return ballY + ballR;
}

// void keyPressed() {
// 	if (key==CODED) {
// 		if (keyCode==UP && paddle1Y >= paddleH) {
// 			pongBoard.emit('move', 'player1', 'up');
// 		} 
// 		if (keyCode==DOWN && paddle1Y <= height - 2 * paddleH) {
// 			pongBoard.emit('move', 'player1', 'down');
// 		} 
// 	}
// }

pongBoard.on('move1', function (tilt) {
	paddle1Y = ((h-border)/2 + (h-border)*tilt.beta/180);
});

pongBoard.on('move2', function (tilt) {
	paddle2Y = ((h-border)/2 + (h-border)*tilt.beta/180);
});

// Event listener for sliding

// pongBoard.on('move1', function(yAcceleration) {
// 	// paddle1Y += yAcceleration;


// 	velocity1 += yAcceleration;
// 	velocity1 *= 0.99;
// 	paddle1Y += 0.1 * velocity1;
// 	// if (Math.abs(velocity1 < 10)) velocity1 = 0;
// 	if (Math.abs(paddle1Y) < 400) {
// 		console.log("SLIIIIIDIIIIIIING: ", yAcceleration, velocity1, paddle1Y);
// 	}
// })

// pongBoard.on('move2', function(direction) {
// 	if (direction=='up') {
// 		paddle2Y=paddle2Y - dPaddle;
// 	} else if (direction =='down') {
// 		paddle2Y=paddle2Y + dPaddle;
// 	}
// })
















