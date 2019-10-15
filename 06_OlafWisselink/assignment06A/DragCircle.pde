class DragCircle {
  float xpos, ypos;
  float xoff, yoff;
  float diam;
  boolean isAttached;

  DragCircle(float xinit, float yinit, float dinit) {
    xpos = xinit;
    ypos = yinit;
    diam = dinit;
    isAttached = false;
  }

  void display() {
    noStroke();
    fill(200);
    
    if (isAttached) {
      fill(#FCBDD5);
      xpos = mouseX - xoff;
      ypos = mouseY - yoff;
    } 
    else {
      fill(#BDEBFC);
    }
    ellipse(xpos, ypos, diam, diam);
  }

  void attach() {
    if (dist(mouseX, mouseY, xpos, ypos) <= diam/2) {
      isAttached = true;
      xoff = mouseX - xpos;
      yoff = mouseY - ypos;
    }
  }

  void detach() {
    isAttached = false;
  }
}
