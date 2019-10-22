// Create a ripple object
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
  // Set the ripple position according to mouse pos
  ripple.init(mouseX, mouseY);
  firstPress = true;
}
