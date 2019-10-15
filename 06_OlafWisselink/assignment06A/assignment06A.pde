int numCircle = 10;
DragCircle drag[] = new DragCircle[numCircle];

void setup() {
  size(512, 512);
  for (int i = 0; i < numCircle; i++) {
    drag[i] = new DragCircle(random(width), random(height), 100);
  }
}

void draw() {
  background(255);
  for (int i = 0; i < numCircle; i++) {
    drag[i].display();
  }
}

void mousePressed() {
  for (int i = 0; i < numCircle; i++) {
    drag[i].attach();
  }
}

void mouseReleased() {
  for (int i = 0; i < numCircle; i++) {
    drag[i].detach();
  }
}
