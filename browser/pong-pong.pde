float w = document.documentElement.clientWidth;
float h = document.documentElement.clientHeight;
float border = 10;
float boardWidth = w - border;
float boardHeight = h - border;
float originalBallX = boardWidth / 2;
float originalBallY = boardHeight / 2;
float ballX = originalBallX;
float ballY = originalBallY;
float ballR = 10;
float dX = random(8, 12);
float dY = random(-2, 2);
float speedBase = 10;
float paddle1X;
float paddle1Y = (h-2*border)/2;
float paddle2X;
float paddle2Y = 10;
float paddleW = 30;
float paddleH = h/5;
float dPaddle = paddleH;

float velocity1 = 0;
float velocity2 = 0;
float easing = 0.05;
float player1score = 0;
float player2score = 0;

class PVector {
	float x;
	float y;

	PVector(float x_, float y_) {
		x = x_;
		y = y_;
	}

	void add(PVector v) {
		y = y + v.y;
		x = x + v.x;
	}

	void sub(PVector v) {
    	x = x - v.x;
    	y = y - v.y;
  	}

  	void mult(float n) {
   		x = x * n;
   		y = y * n;
 	}

 	void div(float n) {
  		x = x / n;
  		y = y / n;
	}

	void normalize() {
 		float m = mag();
 		if (m != 0) {
   			div(m);
 		}
	}

	void limit(float max) {
		if (mag() > max) {
			normalize();
			mult(max);
		}
	}

 	float mag() {
  		return sqrt(x*x + y*y);
	}
}

class Mover {
	PVector location;
	PVector velocity;
	PVector acceleration;
	float topSpeed;

	void update() {
		velocity.add(acceleration);
		velocity.limit(topSpeed);
		location.add(velocity);
	}

	void display() {
		stroke(0);
		fill(255);
		ellipse(location.x, location.y, 2 * ballR, 2 * ballR);
	}

	Mover(float locationX, float locationY, float velocityX, float velocityY, float accelX, float accelY, float maxSpeed) {
    	location = new PVector(locationX, locationY);
    	velocity = new PVector(velocityX, velocityY);
    	acceleration = new PVector(accelX, accelY);
    	topSpeed = maxSpeed;
  	}

  	void checkEdges() {
  		checkCollisions();
  		checkTopEdges();
  		checkSideEdges();	 
	}

	void checkCollisions() {

	}

	void checkTopEdges() {
	    if (ballBottom() > height || ballTop() < 0) {
	      velocity.y = -velocity.y;
	    }
	}

	void checkSideEdges() {
		if (ballRight() > width) {
			player1score++;
			location.x = originalBallX;
			location.y = originalBallY;
			velocity.x = random(-(speedBase - 2), -(speedBase + 2));
			velocity.y = random(-2, 2);
			speedBase++;
		}

		if (ballLeft() < 0) {
			player2score++;
			location.x = originalBallX;
			location.y = originalBallY;
			velocity.x = random(speedBase - 2, speedBase + 2);
			velocity.y = random(-2, 2);
			speedBase++;
		}
	}


	float ballLeft() {
		return location.x - ballR;
	}

	float ballRight() {
		return location.x + ballR;
	}

	float ballTop() {
		return location.y - ballR;
	}

	float ballBottom() {
		return location.y + ballR;
	}



}



// float originalBallX = boardWidth / 2;
// float originalBallY = boardHeight / 2;
// float ballX = originalBallX;
// float ballY = originalBallY;
// float ballR = 10;
// float dX = random(8, 12);
// float dY = random(-2, 2);
// float speedBase = 10;
// float paddle1X;
// float paddle1Y = (h-2*border)/2;
// float paddle2X;
// float paddle2Y = 10;
// float paddleW = 30;
// float paddleH = h/5;
// float dPaddle = paddleH;

// float velocity1 = 0;
// float velocity2 = 0;
// float easing = 0.05;
// float player1score = 0;
// float player2score = 0;


/* @pjs font='8-bit-wonder.TTF'; */
PFont font_name;

var audio = document.getElementById('music');

audio.play();

void setup() {
	size(boardWidth, boardHeight);
	paddle1X = boardWidth - paddleW - 1;
	paddle2X = 0;
	font_name = loadFont('8-bit-wonder.ttf');
	textFont(font_name, 32);

	ball = new Mover(boardWidth / 2, boardHeight / 2, random(8, 12), random(-2, 2), 0, 0, 25);
}

void draw() {  
	background(0, 0, 0);
	textSize(100);
	text(player1score, boardWidth * 0.3, 100, 100, 100);
	text(player2score, boardWidth * 0.7 - 60, 100, 100, 100);
	ellipse(ballX, ballY, 2 * ballR, 2 * ballR);
	rect(paddle1X, paddle1Y, paddleW, paddleH);
	rect(paddle2X, paddle2Y, paddleW, paddleH);
	for (int i = 0; i < 23; i++) {
		if (i % 2 == 0) {
			rect(boardWidth / 2, i * boardHeight / 23, 10, boardHeight / 23);
		}
	}


	// Scoring conditions

	if (ballRight() > width) {
		player1score++;
		ballX = originalBallX;
		ballY = originalBallY;
		dX = random(-(speedBase - 2), -(speedBase + 2));
		dY = random(-2, 2);
		if (speedBase < 23) {
			speedBase++;
		}
	}

	if (ballLeft() < 0) {
		player2score++;
		ballX = originalBallX;
		ballY = originalBallY;
		dX = random(speedBase - 2, speedBase + 2);
		dY = random(-2, 2);
		if (speedBase < 23) {
			speedBase++;
		}
	}

	// Victory conditions

	if (player1score > 10) {
		translate(boardWidth / 2, boardHeight / 2);
		textAlign(CENTER, CENTER);
		text("PLAYER 1 WINS", 50, 50);
		noLoop();
	}

	if (player2score > 10) {
		translate(boardWidth / 2, boardHeight / 2);
		textAlign(CENTER, CENTER);
		text("PLAYER 2 WINS", 50, 50);
		noLoop();
	}

	if (collision()) {
		if (Math.abs(dX) < 25) {
			dX = -1.1 * dX;
		} else {
			dX = -dX;
		}
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
			float awesomeness = ballY - paddle1Y - paddleH / 2;
			dY += 0.05 * awesomeness;
			returnValue = true;
		}
	}
	if ((ballLeft() <= paddle2X + paddleW) && (ballRight() >= paddle2X + paddleW)) {
		if ((ballBottom() >= paddle2Y) && (ballTop() <= paddle2Y + paddleH)) {
			float awesomeness = ballY - paddle2Y - paddleH / 2;
			dY += 0.05 * awesomeness;
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

pongBoard.on('move1', function (tilt) {
	paddle1Y = ((boardHeight)/2 + (boardHeight)*tilt.beta/180);
});

pongBoard.on('move2', function (tilt) {
	paddle2Y = ((boardHeight)/2 + (boardHeight)*tilt.beta/180);
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
















