void setup() {
  size(512, 512);
}

void draw() {
  background(255);
  gridDraw(mouseX, mouseY, 10, 10, 400, 400);
}

void gridDraw(float xpos, float ypos, int rows, int cols, float w, float h) {
  // Draw for r <= rows and c <= cols because we need to close the grid with one last extra line
  
  // Horizontal lines
  for (int r = 0; r <= rows; ++r) {
    // What's the spacing between the lines?
    // Amount of y spacing = row number * height / number of horizontal lines (rows)
    // Offset the lines with the xpos and ypos (mouse position)
    float yspacing = r * h / (float)rows;
    line(xpos, ypos + yspacing, xpos + w, ypos + yspacing);
  }
  
  // Vertical lines
  for (int c = 0; c <= cols; ++c) {
    // Amount of x spacing = column number * width / number of vertical lines (cols)
    float xspacing = c * w / (float)cols;
    line(xpos + xspacing, ypos, xpos + xspacing, ypos + h);
  }
}
