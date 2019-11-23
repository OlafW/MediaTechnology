public class ChildApplet extends PApplet {
  int ID;

  int windowX, windowY;
  color bg; 
  
  boolean mouseOver = false;
  boolean speak = false;
  int beginWindowWidth;
  
  public ChildApplet(int ID, boolean speak) {
    super();
    this.ID = ID;
    this.speak = speak;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size((int)random(128, 250), (int)random(128, 250));
    beginWindowWidth = width;
  }

  public void setup() {
    surface.setTitle(str(ID));
    surface.setAlwaysOnTop(true);

    windowX = (int)random(displayWidth - this.width);
    windowY = (int)random(displayHeight - this.height - 75);
    surface.setLocation(windowX, windowY);
    
    bg = color(random(255), random(255), random(255));
    
    if (speak && !speech.isAlive()) {
      speak("Hi, I'm program" + ID);
    }
  }

  public void draw() {
    fill(0);
    noStroke();
        
    if (this.ID == randWindow) {   
      if (video != null) {
        image(video, 0, 0);
      }
      
      else {
        background(random(255));
        ellipse(beginWindowWidth + 100, height/2, 75, 75);
      }
    }
    
    else {
      if (mouseOver) background(255);
      else background(bg);
      ellipse(width/2, height/2, 75, 75);
    }
  }
  
  public void mouseEntered() {
    mouseOver = true;
  }
  public void mouseExited() {
    mouseOver = false;
  }

  public void exit() {
    dispose();
    surface.setVisible(false);
  }
  
  public void startVideo() {
    video = new Capture(this, width, height);
    video.start();  
  }
  
  public void captureEvent(Capture video) {
    video.read();
  }
  
  public boolean foundCircle() {
    return (width > beginWindowWidth + 150);  
  }
}
