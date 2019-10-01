void setup() {
  size(512, 512);
  background(255);
  
  float radius = 64; // initial circle radius
  float overlap = 3.5; // vertical overlap factor;
  int cols = int(width/radius) + 1; // number of horizontal circles
  int rows = int(height/radius * overlap) + 1; // number of vertical circles
  
  // Nested for loop draws grid of circles
  // The rows of circles get drawn on top of each other
  // If we're at an even row: translate radius/2 right
  
  translate(0, radius/4);
  for (int y = 0; y < rows; ++y) {    
    for (int x = 0; x < cols; ++x) {
      pushMatrix();
      
      if (y % 2 == 0) translate(radius/2, 0);
      drawCircles(x * radius, y * radius/overlap, radius);
      
      popMatrix();
    }
  }
}

void drawCircles(float x, float y, float radius) {
  int numCircle = 4;
  float bright = 255; // (0 - 255)
  float bright_offset = 0.5; // (0 - 1)
  
  for (int i = numCircle; i > 0; i--) {
    // For loop is in reverse to draw from big to smaller circles
    // For every circle, decrease the radius by factor r
    float r = i / float(numCircle);
    
    // For every circle, increase the green and blue values to add white
    float whiteness = (1.0-r + bright_offset) * bright;
    color col = color(255, whiteness, whiteness);
    
    fill(col);
    noStroke();
    strokeWeight(2);
    stroke(150, 50, 50);
    ellipse(x, y, r * radius, r * radius);
  }
}

void draw() {}
