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
    
    // If circle is pressed
    // circlepos = mousepos - offset
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
    // Did we press this circle?
    // Is the mousepointer within the radius?
    
    float dist = dist(mouseX, mouseY, xpos, ypos);
    if (dist <= diam/2) {
      isAttached = true;
      
      // Set the offset: Where did we press in the circle relative to its center?
      xoff = mouseX - xpos;
      yoff = mouseY - ypos;
    }
  }

  void detach() {
    isAttached = false;
  }
}
