boolean clicked = false;

void setup() {
  size(512, 512);
}

void draw() {
  background(255);
  fill(0);
  stroke(0);
  float xpos = mouseX;
  float ypos = mouseY;
  
  // If mouseclicked invert colors
  if (clicked) {
    background(0);
    fill(255);
    stroke(255);
  }
  
  // Evenly space 11 circles horizontally and vertically
  // Even spacing = 1/10 * width or height for every circle
  for (int i = 10; i >= 0; i--) {
    ellipse(i / 10.0 * width, ypos, 4, 4);
    ellipse(xpos, i / 10.0 * height, 4, 4);
  }
  
  // Make vertical line
  line(0, ypos, width, ypos);
  line(xpos, 0, xpos, height);
  
  ellipse(xpos, ypos, 20, 20);
}


// Set boolean if clicked or released
void mousePressed() {
  clicked = true;
}

void mouseReleased() {
  clicked = false;
}
