class Ripple {
  float x, y;
  float r;
  float max_r = 400;
  
  float alpha = 255;
  float strokeW = 3.0;
    
  void set(float x, float y) {
   this.x = x;
   this.y = y;
   r = 0;
   alpha = 255;
   strokeW = 3;
  }
  
  void display() {
    noFill();
    stroke(0, 0, 255, alpha);
    strokeWeight(strokeW);
    
    ellipse(x, y, r, r);
    
    if (r < max_r) r += 2;
    alpha *= 0.95;
    strokeW *= 1.02;
  }
}
