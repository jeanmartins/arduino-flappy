import processing.serial.*;
Serial myPort;
int buttonState;
int birdX, birdY, birdSize;
int obstacleX, obstacleY, obstacleWidth, obstacleHeight;
int gapSize;
int score;
boolean gameRunning;

void setup() {
  size(500, 500);
  myPort = new Serial(this, Serial.list()[1], 9600 );;
  resetGame();
}

void resetGame() {
  birdX = width/4;
  birdY = height/2;
  birdSize = 30;
  obstacleX = width;
  obstacleWidth = 40;
  gapSize = 120;
  obstacleY = int(random(gapSize/2, height - gapSize/2 - obstacleHeight));
  obstacleHeight = int(random(50, 200));
  score = 0;
  gameRunning = true;
}

void verifyButton() {
    if (myPort.available() > 0) {
    buttonState = int(myPort.read());
  }
  
    if (buttonState == 1) {
      birdY -= 10; 
  }
  
  if (buttonState == 1 && !gameRunning ) {
    resetGame();  
  }
  
  println(buttonState);
}

void draw() {
  background(255);
  if (gameRunning) {
    moveBird();
    moveObstacle();
    checkCollisions();
    drawBird();
    drawObstacle();
    drawScore();
  } else {
    drawGameOver();
  }
  verifyButton();
}

void moveBird() {
  birdY += 3;
}

void moveObstacle() {
  obstacleX -= 5;
  if (obstacleX < -obstacleWidth) {
    obstacleX = width;
    obstacleHeight = int(random(50, 200));
    obstacleY = int(random(gapSize/2, height - gapSize/2 - obstacleHeight));
    score++;
  }
}

void checkCollisions() {
  if (birdY < 0 || birdY > height) {
    gameRunning = false;
    myPort.write(1);
  }
  if (birdX + birdSize > obstacleX && birdX < obstacleX + obstacleWidth) {
    if (birdY < obstacleY || birdY + birdSize > obstacleY + gapSize) {
      gameRunning = false;
      myPort.write(1);
    }
  }
}

void drawBird() {
  fill(255, 0, 0);
  rect(birdX, birdY, birdSize, birdSize);
}

void drawObstacle() {
  fill(0, 255, 0);
  rect(obstacleX, 0, obstacleWidth, obstacleY);
  rect(obstacleX, obstacleY + gapSize, obstacleWidth, height - obstacleY - gapSize);
}

void drawScore() {
  fill(0);
  textSize(20);
  textAlign(LEFT, TOP);
  text("Score: " + score, 10, 10);
}

void drawGameOver() {
  fill(0);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Game Over", width/2, height/2);
  textSize(20);
  text("Press space to play again", width/2, height/2 + 50);
}

void keyPressed() {
  if (keyCode == ' ' && !gameRunning) {
    resetGame();
  }
  if (keyCode == ' ') {
    birdY -= 100;
  }
}
