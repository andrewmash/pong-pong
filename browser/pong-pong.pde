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
		display();
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
		checkLeftPaddle();
		checkRightPaddle();
		// checkBumpers();
	}

	void checkTopEdges() {
    if (ballBottom() > height || ballTop() < 0) {
      	boom.play();
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

	void checkRightPaddle() {
		if ((ballRight() >= paddle1X) && (ballLeft() <= paddle1X)) {
			if ((ballBottom() >= paddle1Y) && (ballTop() <= paddle1Y + paddleH)) {
				if (music.paused) boing.play();
				float awesomeness = location.y - paddle1Y - paddleH / 2;
				velocity.y += 0.08 * awesomeness;
				velocity.x = -1.1*velocity.x
			}
		}
	}

	void checkLeftPaddle() {
		if ((ballLeft() <= paddle2X + paddleW) && (ballRight() >= paddle2X + paddleW)) {
			if ((ballBottom() >= paddle2Y) && (ballTop() <= paddle2Y + paddleH)) {
				if (music.paused) tschak.play();
				float awesomeness = location.y - paddle2Y - paddleH / 2;
				velocity.y += 0.08 * awesomeness;
				velocity.x = -1.1*velocity.x
			}
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

class Bumper {
	PVector location;
	float radius;
	float maxRadius;
	boolean growing;

	void update() {
		display();
		updateSize();
	}

	void display() {
		stroke(0);
		fill(204, 155, 255);
		ellipse(location.x, location.y, 2 * radius, 2 * radius);
	}

	Bumper(float locationX, float locationY, float maxR, float r, boolean grow) {
    	location = new PVector(locationX, locationY);
    	radius = r;
    	maxRadius = maxR;
    	growing = grow;
  }

  void updateSize() {
  	if (growing) {
  		if (radius < maxRadius) {
  			radius += 0.5;
  		} else {
  			growing = false;
  			radius -= 0.5;
  		}
  	} else {
  		if (radius > 0) {
  			radius -= 0.5;
  		} else {
  			growing = true;
  			location.x = random(30, boardWidth-30);
  			location.y = random(30, boardHeight-30);
  			maxRadius = random(20, 60);
  		}
  	}
  }
}

/* @pjs font='8-bit-wonder.TTF'; */
PFont font_name;

var music = document.getElementById('music');
var boing = document.getElementById('boing');
var boom = document.getElementById('boom');
var tschak = document.getElementById('tschak');

void setup() {
	size(boardWidth, boardHeight);
	paddle1X = boardWidth - paddleW - 1;
	paddle2X = 0;
	font_name = loadFont('8-bit-wonder.ttf');
	textFont(font_name, 32);

	ball = new Mover(boardWidth / 2, boardHeight / 2, random(8, 12), random(-2, 2), 0, 0, 15);
	bumper = new Bumper(random(30, boardWidth-30), random(30, boardHeight-30), 20, 0, true);
}

void draw() {  
	background(0, 0, 0);
	textSize(100);
	text(player1score, boardWidth * 0.3, 100, 100, 100);
	text(player2score, boardWidth * 0.7 - 60, 100, 100, 100);
	
	//player paddles
	rect(paddle1X, paddle1Y, paddleW, paddleH);
	rect(paddle2X, paddle2Y, paddleW, paddleH);
	
	//dotted center line
	for (int i = 0; i < 23; i++) {
		if (i % 2 == 0) {
			rect(boardWidth / 2, i * boardHeight / 23, 10, boardHeight / 23);
		}
	}

	// Victory conditions

	if (player1score + player2score === 3 && music.paused) music.play();
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

	ball.checkEdges();
	ball.update();
	bumper.update();
}

pongBoard.on('move1', function (tilt) {
	paddle1Y = ((boardHeight)/2 + (boardHeight)*tilt.beta/120) - paddleH/2;
});

pongBoard.on('move2', function (tilt) {
	paddle2Y = ((boardHeight)/2 + (boardHeight)*tilt.beta/120) - paddleH/2;
});















