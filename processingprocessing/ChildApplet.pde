public class ChildApplet extends PApplet {
  int ID;

  int windowX, windowY;
  float x, y;
  float diam = 75;
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
    
    x = width/2;
    y = height/2;
    
    bg = color(random(255), random(255), random(255));
    
    if (speak && !speech.isAlive()) {
      speak("Hi, I'm program" + ID);
    }
  }

  public void draw() {
    fill(0);
    noStroke();
        
    if (ID == randWindow) {   
      if (video != null) {
        image(video, 0, 0);
      }
      
      else {
        background(random(255));
        ellipse(beginWindowWidth + 100, height/2, 75, 75);
      }
      
      if (mic != null && amp != null) {
        diam = 125;
        float amplitude = amp.analyze() * 75.0;
        
        if (!speech.isAlive()) {
          x += random(-1, 1) * amplitude;
          y += random(-1, 1) * amplitude;
        }
        x = constrain(x, diam/2, width-diam/2);
        y = constrain(y, diam/2, height-diam/2);
        
        ellipse(x, y, diam, diam);
      }
    }
    
    else {
      if (mouseOver) background(255);
      else background(bg);
      ellipse(x, y, diam, diam);
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
}
