/* 
  Class ChildApplet
  A class that extends the main PApplet class
  This is basically a sketch within a sketch
  Handles its own draw(), mousePressed() etc.
*/

public class ChildApplet extends PApplet {
  int ID;

  int windowX, windowY;
  int beginWindowWidth;
  float circleX, circleY;
  
  float diam = 75;
  color bg; 
  float n_bg;

  boolean mouseOver = false;
  boolean beginSpeak = false;
  boolean endSpeak = true;
  boolean foundRandWindow = false;
  boolean clickedCircle = false;

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

    circleX = width/2;
    circleY = height/2;

    bg = color(random(255), random(255), random(255));

    if (beginSpeak && !speech.isAlive()) {
      speak("Hi, I'm program" + ID);
    }
  }

  public void draw() {
    fill(0);
    noStroke();

    if (ID == randWindow) {   
      if (!foundRandWindow) {
        background(random(255));
      }
      else background(255);
      
      n_bg += 0.075;
      ellipse(beginWindowWidth + 100, height/2, diam, diam);
    } 
    else {
      if (mouseOver) background(255);
      else background(bg);
      ellipse(circleX, circleY, diam, diam);
    }
  }

public void mousePressed() {
    if (!speech.isAlive()) {

      if (ID == randWindow) {
        foundRandWindow = true;
        
        switch(sentenceID) {
        
        case "clickCircle":
          float dist = dist(mouseX, mouseY, beginWindowWidth + 100, height/2);
          if (dist < diam * 0.5) {
            clickedCircle = true;
          }
          break;
        
        default:
          ChildApplet ch;

          for (int i = child.size()-1; i >= 0; i--) {
            ch = child.get(i);

            if (ch != this) {
              ch.endSpeak = false;
              ch.exit();
            }
          }
          break;
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
      speak("Uh-uh, don't do that!");
    }    

    if (child.size() > 1 && endSpeak) {
      int randombluh = (int)random(bluh.length);
      speak(bluh[randombluh]);
    }

    dispose();
    surface.setVisible(false);
  }

  public boolean foundCircle() {
    return (width > beginWindowWidth + 150);
  }
  
  public void mouseEntered() {
    mouseOver = true;
  }

  public void mouseExited() {
    mouseOver = false;
  }
}
