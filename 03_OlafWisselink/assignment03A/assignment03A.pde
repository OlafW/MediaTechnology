void setup() {
  size(512, 512);
}

void draw() {
  background(255);
  gridDraw(mouseX, mouseY, 10, 10, 400, 400);
}

void gridDraw(float xpos, float ypos, int rows, int cols, float w, float h) {
  // Make a nested for loop to draw a grid of lines
  // Draw for r <= rows and c <= cols because we need to close the grid with one last extra line
  for (int r = 0; r <= rows; ++r) {
    for (int c = 0; c <= cols; ++c) {
      // What's the spacing between the lines?
      // Amount of y spacing = row number * height / number of horizontal lines (rows)
      // Amount of x spacing = column number * width / number of vertical lines (cols)
      float yspacing = r * h / (float)rows;
      float xspacing = c * w / (float)cols;
     
      // Draw a horizontal and vertical line
      // Offset the lines with the xpos and ypos (mouse position)
      line(xpos, ypos + yspacing, xpos + w, ypos + yspacing);
      line(xpos + xspacing, ypos, xpos + xspacing, ypos + h);
    }
  }
}
