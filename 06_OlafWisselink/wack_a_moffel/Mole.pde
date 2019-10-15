class Mole {
  float x, y;
  boolean isHetMoffel;
  boolean wacked;
  
  float dissapearTime;
  float time;
  
  Mole() {
    init(true);
  }
   
  int wack(float mx, float my) {
    int score = 0;
    
    if (!wacked) {
      if ( (mx > x && mx < x + moffel.width) &&
           (my > y && my < y + moffel.height)) {
             
       wacked = true;
       time = millis();
       
       if (isHetMoffel) score = 1;
       else score = -1;
     }
     else score = 0;
  }
  return score;
  }
  
  void RandomlyReappear() {
    float deltaT = millis() - time;
    
    if (deltaT > dissapearTime) {
      init(false);
    }
  }
  
  void init(boolean wacked) {
    this.wacked = wacked;
    isHetMoffel = random(2) < 1;
    x = random(width - moffel.width);
    y = random(height - moffel.height);
        
    time = millis();
    dissapearTime = random(500, 5000);
  }
  
  void display() {
    if (!wacked) {
      if (isHetMoffel) {
        image(moffel, x, y);
      }
      else {
        image(piertje, x, y);
      }
    }
  }
}
