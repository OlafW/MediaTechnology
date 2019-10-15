Ripple ripple = new Ripple();
boolean firstPress = false;

void setup() {
  size(500, 500);
}

void draw() {
  background(255);
  if (firstPress) ripple.display();
}

void mousePressed() {
  ripple.set(mouseX, mouseY);
  firstPress = true;
}
