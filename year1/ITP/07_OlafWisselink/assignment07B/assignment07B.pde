// Number of mouse positions to track
int numPoints = 50;

// 2-dimensional array stores x and y mouse positions
int[][] mouse = new int[numPoints][2];
int writePtr = 0;

void setup() {
  size(512, 512);
}

void draw() {
  background(255);
  
  // Write to current mouse pos to the array at the write pointer
  mouse[writePtr][0] = mouseX;
  mouse[writePtr][1] = mouseY;
  
  float r, alpha;
  
  for (int i = 0; i < numPoints; i++) {
    // Read from the array starting at the writepointer 
    int readPtr = (i + writePtr) % numPoints;
    
    // Map radius and alpha to i
    // This way r and alpha continously change for every circle because 
    // the readpointer keeps reading out from different points in the array
    r = map(i, 0, numPoints, 5, 50);
    alpha = map(i, 0, numPoints, 25, 255);
    
    fill(0, alpha);
    noStroke();
    ellipse(mouse[readPtr][0], mouse[readPtr][1], r, r);
  }
  
  // Increment write pointer
  if (writePtr < numPoints - 1) writePtr++;
  else writePtr = 0;
}
