class Mole {
  float x, y;
  boolean isHetMoffel;
  boolean visible;

  float waitTime;
  float time;

  Mole() {
    visible = true;
    init();
  }

  int wack(float mx, float my) {
    int score = 0;

    // Check if we clicked within the image, which is a rectangle
    // Only do this when its not waiting to reappear after being wacked
    if (visible) {
      if ( (mx > x && mx < x + moffel.width) &&
           (my > y && my < y + moffel.height)) {

        // Return a score
        if (isHetMoffel) score = 1;
        else score = -1;
        
        // Initialise again 
        init();
      } 
      else score = 0;
    }
    
    return score;
  }

  void RandomlyReappear() {
    // How much time is passed since we set time?
    float deltaT = millis() - time;

    // Check if the waiting time is over
    if (deltaT > waitTime) {
      init();
    }
  }

  void init() {
    isHetMoffel = random(2) < 1;
    
    x = random(width - moffel.width);
    y = random(height - moffel.height);

    // Set the time and random wait time
    // Waiting time for appearing and waiting to appear are different
    if (visible) waitTime = random(1500, 3000); 
    else waitTime = random(500, 2000);
    visible = !visible;
    
    time = millis();
  }

  void display() {
    // Don't draw if wacked or dissapeared
    if (visible) {
      if (isHetMoffel) {
        image(moffel, x, y);
      } else {
        image(piertje, x, y);
      }
    }
  }
}
