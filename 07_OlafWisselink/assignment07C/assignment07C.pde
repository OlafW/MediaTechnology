int numCircle = 40;
RandCircle[] circle = new RandCircle[numCircle];

void setup() {
  size(512, 512);

  for (int i = 0; i < numCircle; i++) {
    circle[i] = new RandCircle(random(width), random(height), circle);
  }

  for (int i = 0; i < numCircle; i++) {
    circle[i].setRandPosition();
  }

}

void draw() {
  background(255);

  for (int i = 0; i < numCircle; i++) {
    circle[i].display();
  }
}

void mousePressed() {
  for (int i = 0; i < numCircle; i++) {
    circle[i].clicked(mouseX, mouseY);
  }
}
