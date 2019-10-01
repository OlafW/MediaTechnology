void setup() {
  size(512, 512);
  background(255);
  rectMode(CENTER);
  
  int numRect = 6;
  int rectHeight = 375;
  int rectWidth = 60;  
  
  // Amount of rotation per rectangle in radians
  float phi = 1.0 / float(numRect * 2) * TWO_PI;
  
  // Set coordinate system to the center of the screen
  // Rotate phi/2 so no they're no horizontal or vertical rectangles
  translate(width/2, height/2);
  pushMatrix();
  rotate(phi*0.5);
  
  // For every rectangle, rotate phi radians
  // This is incremental because we don't use popMatrix()
  for (int i = 0; i < numRect; i++) {
    rotate(phi);
    noStroke();
    fill(255, 125, 0);
    rect(0, 0, rectHeight, rectWidth);
  }
  
  // Reset coordinate system to last push
  popMatrix();
  
  // Draw white circle
  fill(255);
  ellipse(0, 0, 150, 150);
  
  // Draw yellow circle
  fill(255, 200, 0);
  ellipse(0, 0, 100, 100);
}

void draw() {
}
