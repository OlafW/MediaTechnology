public class ChildApplet extends PApplet {
  int ID;

  int windowX, windowY;
  float x, y;
  float diam = 75;
  color bg; 
  
  boolean mouseOver = false;
  boolean beginSpeak = false;
  boolean endSpeak = true;
  int beginWindowWidth;
    
  public ChildApplet(int ID, boolean beginSpeak) {
    super();
    this.ID = ID;
    this.beginSpeak = beginSpeak;
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
    
    x = width/2;
    y = height/2;
    
    bg = color(random(255), random(255), random(255));
    
    if (beginSpeak && !speech.isAlive()) {
      speak("Hi, I'm program" + ID);
    }
  }

  public void draw() {
    fill(0);
    noStroke();
        
    if (ID == randWindow) {   
      if (video != null) {
        image(video, 0, 0);
        ellipse(x, y, diam, diam);
      }
      
      else {
        background(random(255));
        ellipse(beginWindowWidth + 100, height/2, 75, 75);
      }
      
      if (mic != null && amp != null) {
        
        float amplitude = amp.analyze() * 75.0;
        
        if (!speech.isAlive()) {
          x += random(-1, 1) * amplitude;
          y += random(-1, 1) * amplitude;
        }
      }
    }
    
    else {
      if (mouseOver) background(255);
      else background(bg);
      ellipse(x, y, diam, diam);
    }
  }
  
  public void mousePressed() {
    if (!speech.isAlive()) {
      
      if (ID == randWindow) {        
        ChildApplet ch;
        
        for (int i = child.size()-1; i >= 0; i--) {
          ch = child.get(i);
          
          if (ch != this) {
            ch.endSpeak = false;
            ch.exit();
          }
        } 
      }
      
      else {
        endSpeak = true;
        exit();
      }
    }
  }
  
  public void exit() {
    if (ID == randWindow) {
      endSpeak = false;
    }    
    
    if (child.size() > 0 && endSpeak) {
      int randombluh = (int)random(bluh.length);
      speak(bluh[randombluh]);
    }
    
    dispose();
    surface.setVisible(false);
  }
  
  public void startVideo() {
    video = new Capture(this, width, height);
    video.start();  
    
    diam = 125;
    x = width/2;
    y = height/2;
  }
  
  public void startAudio() {
    mic = new AudioIn(this, 0);
    mic.start();
    amp = new Amplitude(this);
    amp.input(mic);
  }
  
  public void captureEvent(Capture video) {
    video.read();
  }
  
  public boolean foundCircle() {
    return (width > beginWindowWidth + 150);  
  }
  
  public boolean circleOffScreen() {
    return (x < -diam/2 || x > width + diam/2 ||
            y < -diam/2 || y > height + diam/2);
  }
  
  public void mouseEntered() {
    mouseOver = true;
  }
  public void mouseExited() {
    mouseOver = false;
  }
}
