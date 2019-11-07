class RandCircle {
  float x, y;
  float diam = 60;
  RandCircle[] circle;

  RandCircle(float x, float y, RandCircle[] circle) {
    this.x = x;
    this.y = y;
    this.circle = circle;
  }

  void setRandPosition() {
    boolean collided;
    boolean foundEmptySpot = false;

    // While we haven't found a random empty spot...
    while (!foundEmptySpot) {
      collided = false;

      // ..Set a random position
      x = random(width);
      y = random(height);

      // ..If we're outside of the canvas, set a new random position until we're not anymore
      while (x - diam * 0.5 < 0 || x + diam * 0.5 > width || 
             y - diam * 0.5 < 0 || y + diam * 0.5 > height) {
        x = random(width);
        y = random(height);
      }

      // ...Then for every circle, check if we aren't colliding
      // If we are, break out of the for loop and start all over again!
      // Don't check against itself
      for (int i = 0; i < circle.length; i++) {
        if (circle[i] != this) {
          float dist = dist(x, y, circle[i].x, circle[i].y);

          if (dist <= diam) {
            collided = true;
            break;
          }
        }
      }
      // We haven't collided or are over the window's edges, so..
      // We found an empty spot, hooray!
      if (!collided) foundEmptySpot = true;
    }
  }

  void display() {
    noStroke();
    fill(100);
    ellipse(x, y, diam, diam);
  }

  void clicked(float mx, float my) {
    float dist = dist(x, y, mx, my);

    // We clicked on this circle, reset it's position
    if (dist < diam / 2) {
      setRandPosition();
    }
  }
}
