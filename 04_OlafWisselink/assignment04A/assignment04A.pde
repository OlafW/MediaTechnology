void setup() {
  size(512, 512);
  background(255);
  
  int numRect = 3;
  int rectSize = width / numRect;
  
  // Make a grid of rectangles
  // For every even rectangle: drawRandomRect()
  
  for (int i = 0; i < numRect; ++i) {
    for (int j = 0; j < numRect; ++j) {
      // rect index = i * number of rect + j
      // index is even when divisible by 2
      if ((i * numRect + j) % 2== 0) {
        drawRandomRect(i * rectSize, j * rectSize, rectSize);
      }
    }
  }
  
  // For every uneven rect: draw white rectangle
  for (int i = 0; i < numRect; ++i) {
    for (int j = 0; j < numRect; ++j) {
      if ((i * numRect + j) % 2 != 0) {
        fill(255);
        noStroke();
        rect(i * rectSize, j * rectSize, rectSize, rectSize);
      }
    }
  }
}

void drawRandomRect(float x, float y, float r) {
  float randPosX;
  float randPosY;
  float randWidth;
  float randHeight;
  color randColor;
  int randShape;
  
  // Draw some random shapes
  for (int i = 0; i < 150; ++i) {
    // random position is random(current x or y + rect size)
    randPosX = random(x, x + r);
    randPosY = random(y, y + r);
    randWidth = random(10, 75);
    randHeight = random(10, 75);
    
    randColor = color(random(50, 255), random(25, 255), 75, random(100, 175));
    fill(randColor);
    noStroke();
    
    // Choose randomly between ellipse or rectangle
    randShape = (int)random(2);
    if (randShape == 0) {
      ellipse(randPosX, randPosY, randWidth, randHeight);
    }
    else {
      rect(randPosX, randPosY, randWidth, randHeight);
    }
  }
}

void mousePressed() {
  setup();
}

void draw() {
}
