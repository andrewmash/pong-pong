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
float paddleW = 30;
float paddleH = h/5;
float paddle1X;
float paddle1Y = (h-2*border)/2-paddleH/2;
float paddle2X;
float paddle2Y = (h-2*border)/2-paddleH/2;
float dPaddle = paddleH;

float bumperGrowthRate = 0.5;
float wellGrowthRate = 1.5;

float velocity1 = 0;
float velocity2 = 0;
float easing = 0.05;
float player1score = 0;
float player2score = 0;

boolean playing = false;

var players = [];
var bumpers = [];
var wells = [];

class Mover {
	PVector location;
	PVector velocity;
	PVector acceleration;
	float topSpeed;
	float mass;

	void update() {
		velocity.add(acceleration);
		velocity.limit(topSpeed);
		location.add(velocity);
		acceleration.mult(0);
		display();
	}

	void applyForce (PVector force) {
		PVector f = force.get();
		// f.div(mass);
		acceleration.add(f);
	}

	void display() {
		stroke(0);
		fill(255);
		ellipse(location.x, location.y, 2 * ballR, 2 * ballR);
	}

	Mover(float locationX, float locationY, float velocityX, float velocityY, float accelX, float accelY, float maxSpeed) {
	mass = 1;
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
		checkBumpers();
		checkWells();
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
			velocity.x = speedBase
			velocity.y = random(-4, 4);
			speedBase = speedBase + 0.25;
		}

		if (ballLeft() < 0) {
			player2score++;
			location.x = originalBallX;
			location.y = originalBallY;
			velocity.x = speedBase
			velocity.y = random(-4, 4);
			speedBase = speedBase + 0.25;
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

	void checkBumpers() {
		bumpers.forEach(function(bumper) {
			checkBumper(bumper);
		});
	}

	void checkBumper(bumper) {
		//get distances between the balls
		PVector distanceVector = new PVector(bumper.location.x-location.x, bumper.location.y-location.y);
		float distance = distanceVector.mag();
		//if touching
		if (distance<=bumper.radius+ballR) {
			//get angle of bVect (vector connecting their centers)
			float theta = atan2(distanceVector.x, distanceVector.y);
			rotate(Math.PI*theta/180);
			velocity.x = -velocity.x;
			rotate(-Math.PI*theta/180);
		}
	}

	void checkWells() {
		wells.forEach(function (well) {
			checkWell(well);
		})
	}

	void checkWell (well) {
		PVector dir = PVector.sub(well.location, ball.location);
		float distance = dir.mag();
		distance = constrain(distance, 1, 1000000);
		dir.normalize();
		float m = well.mass / (distance * distance);
		dir.mult(m);
		ball.applyForce(dir);
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
		fill(161, 235, 136);
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
  			radius += bumperGrowthRate;
  		} else {
  			growing = false;
  			radius -= bumperGrowthRate;
  		}
  	} else {
  		if (radius > 0) {
  			radius -= bumperGrowthRate;
  		} else {
  			growing = true;
  			location.x = random(30, boardWidth-30);
  			location.y = random(30, boardHeight-30);
  			maxRadius = random(20, 60);
  		}
  	}
  }
}

class Well {
	PVector location;
	float maxRadius;
	float radius;
	boolean growing;
	float mass;

	void update() {
		display();
		updateSize();
	}

	void display() {
		stroke(0);
		if (mass > 0) {
			fill(204, 155, 255);
		} else {
			fill(222, 255, 59);
		}
		ellipse(location.x, location.y, 2 * radius, 2 * radius);
	}

	Well(float locationX, float locationY, float maxR, float r, boolean grow, float weight) {
    	location = new PVector(locationX, locationY);
    	radius = r;
    	maxRadius = maxR;
    	growing = grow;
    	mass = weight;
  }

  void updateSize() {
  	if (growing) {
  		if (radius < maxRadius) {
  			radius += wellGrowthRate;
  		} else {
  			growing = false;
  			radius -= wellGrowthRate;
  		}
  	} else {
  		if (radius > 0) {
  			radius -= wellGrowthRate;
  		} else {
  			growing = true;
  			location.x = random(30, boardWidth-30);
  			location.y = random(30, boardHeight-30);
  			maxRadius = random(20, 60);
  		}
  	}
  }

}

void countDown() {
	textSize(100);
	int count = 3;

	text(count, boardWidth/2-200, boardHeight/2, 800, 800);
	var timer = setInterval(function() {
		count--;
		text(count, boardWidth/2-200, boardHeight/2, 800, 800);
		if (count===0) {
			clearInterval(timer);
			playing = true;
			loop();
		}
	}, 1000);
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

	ball = new Mover(boardWidth / 2, boardHeight / 2, random(8, 12), random(-2, 2), 0, 0, 20);
}

void draw() {
	fill(255)  
	background(0, 0, 0);
	textSize(100);
	text(player1score, boardWidth * 0.3, 100, 100, 100);
	text(player2score, boardWidth * 0.7 - 60, 100, 100, 100);
	
	//player paddles
	rect(paddle1X, paddle1Y, paddleW, paddleH);
	rect(paddle2X, paddle2Y, paddleW, paddleH);

	if (!playing) {
		noLoop();
	}

	if (Math.max(player1score, player2score) === 3 && bumpers.length === 0) {
		bumpers.push(new Bumper(random(100, boardWidth-100), random(100, boardHeight-100), 100, 0, true));
	}

	if (Math.max(player1score, player2score) === 5 && wells.length === 0) {
		wells.push(new Well(random(500, boardWidth - 500), random(500, boardHeight - 500), 50, 0, true, -5000));
	}

	if (Math.max(player1score, player2score) === 7 && bumpers.length === 1) {
		bumpers.push(new Bumper(random(500, boardWidth-500), random(500, boardHeight-500), 50, 0, true));
	}

	if (Math.max(player1score, player2score) === 9 && wells.length === 1) {
		wells.push(new Well(random(500, boardWidth - 500), random(500, boardHeight - 500), 50, 0, true, 5000));
	}
	
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
	bumpers.forEach(function(bumper) {
		bumper.update();
	});
	wells.forEach(function(well) {
		well.update();
	});
}

pongBoard.on('move1', function (tilt) {
	paddle1Y = ((boardHeight)/2 + (boardHeight)*tilt.beta/120) - paddleH/2;
});

pongBoard.on('move2', function (tilt) {
	paddle2Y = ((boardHeight)/2 + (boardHeight)*tilt.beta/120) - paddleH/2;
});

pongBoard.on('play', function() {
	countDown();
});













