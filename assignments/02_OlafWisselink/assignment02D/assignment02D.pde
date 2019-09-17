int box_size;
int item_count = 11;

void setup() {
  size(512, 512);
  setBoxSize();
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    setBoxSize();
  }
}

void setBoxSize() {
  box_size = (int)random(200, 500);
  
  // Make sure box_size is a multiple of item_count
  // That way excactly a whole number of circles fit in the box
  while (box_size % item_count != 0) {
    box_size = (int)random(200, 500);
  }
}

void draw() {
  background(255);
  noStroke();
  fill(0);
  rect(width-box_size, height-box_size, box_size, box_size);
  fill(255, 0, 0);
  
  // Diameter of circle = boxsize / total number of circles
  float diam = box_size / (float)item_count;
  float offset = diam * 0.5;
  
  // Nested for loop creates a grid of circles
  // Position of circle = number of circle * diameter + offset
  for (int i = 0; i < item_count; i++) {
    for (int j = 0; j < item_count; j++) {
      float x = i * diam + width-box_size + offset;
      float y = j * diam + height-box_size + offset;
      ellipse(x, y, diam, diam);
    }
  }
}
