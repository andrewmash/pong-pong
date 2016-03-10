float ballX = 20;
float ballY = 60;
float ballR = 10;
float dX = random(1, 2);
float dY = random(1, 2);
float paddle1X;
float paddle1Y = 10;
float paddle2X;
float paddle2Y = 10;
float paddleW = 10;
float paddleH = 30;
float dPaddle = paddleH;

void setup() {
	size(400, 400);
	paddle1X = width-15;
	paddle2X = 0;
}

void draw() {  
	background(255, 255, 255);
	ellipse(ballX, ballY, 2 * ballR, 2 * ballR);
	rect(paddle1X, paddle1Y, paddleW, paddleH);
	rect(paddle2X, paddle2Y, paddleW, paddleH);


	if (ballRight() > width || ballLeft() < 0) {
		fill(255, 0, 0, 100);
		rect(0, 0, width, height);
		noLoop();
	}

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

void keyPressed() {
	if (key==CODED) {
		if (keyCode==UP && paddle1Y >= paddleH) {
			paddle1Y=paddle1Y - dPaddle;
		} 
		if (keyCode==DOWN && paddle1Y <= height - 2 * paddleH) {
			paddle1Y=paddle1Y + dPaddle;
		} 
		if (keyCode==SHIFT && paddle2Y >= paddleH) {
			paddle2Y=paddle2Y - dPaddle;
		} 
		if (keyCode==CONTROL && paddle2Y <= height - 2 * paddleH) {
			paddle2Y=paddle2Y + dPaddle;
		}
	}
}

