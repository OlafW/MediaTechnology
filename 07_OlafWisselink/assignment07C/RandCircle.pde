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

      // ..Set a random position within the canvas
      x = random(diam/2, width - diam/2);
      y = random(diam/2, height - diam/2);

      // ...Then for every circle, check if we aren't colliding
      // If we are, break out of the for loop and start all over again!
      // Don't check against itself or not-initiated objects
      for (int i = 0; i < circle.length; i++) {
        
        if (circle[i] != this && circle[i] != null) {
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

    // We clicked on this circle, set a new random position
    if (dist < diam / 2) {
      setRandPosition();
    }
  }
}
