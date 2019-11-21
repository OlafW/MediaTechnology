import processing.video.*;

ArrayList<ChildApplet> child = new ArrayList<ChildApplet>();

long speechTime = 0; 
int speechInterval = 3000;
long addWindowTime = 0;
int addWindowInterval = 5000;

int voiceScriptIndex = 4;
boolean continueVoiceScript = true;

Process speech;

char lastKey = ' ';
int reviewTextIndex = 0;

Capture video;

void settings() {
  fullScreen();
  //size(displayWidth, displayHeight);
}

void setup() {
  //String mainTitle = " ";
  //for (int i = 0; i < 50; i++) {
  //  mainTitle += "processing";
  //}
  //surface.setTitle(mainTitle);

  speech = speak(voiceScript[voiceScriptIndex]);
  speechTime = millis();

  initVoiceScript();
}


void draw() {
  background(255);

  fill(0);
  noStroke();
  ellipse(width/2, height/2, 75, 75); 

  int numWindows;

  if (continueVoiceScript) {
    if (!speech.isAlive()) {

      if (millis() - speechTime > speechInterval) {
        speechTime = millis();

        if (voiceScriptIndex < voiceScript.length-1) {
          voiceScriptIndex++;
          speech = speak(voiceScript[voiceScriptIndex]);
        }

        switch(voiceScriptIndex) {

        case 3:
          continueVoiceScript = false;
          break;

        case 6:
          numWindows = 5;

          for (int i = 0; i < numWindows; i++) {
            child.add(new ChildApplet(child.size(), false));
          }
          break;

        case 10:
          numWindows = 50;

          child.clear();
          for (int i = 0; i < numWindows; i++) {
            child.add(new ChildApplet(child.size(), false));
          }
          break;

        case 7: 
        case 11:
          continueVoiceScript = false;
          break;

        case 14:
          child.get(0).getSurface().setResizable(true);
          continueVoiceScript = false;
          break;

        case 17:
          child.get(0).getSurface().setResizable(false);
          child.get(0).getSurface().setSize(512, 512);
          child.get(0).getSurface().setLocation((int)displayWidth/2-256, (int)displayHeight/2-256);
          child.get(0).startVideo();
          continueVoiceScript = false;
          break;
        }
      }
    }
  }

  if (!speech.isAlive()) {
    switch(voiceScriptIndex) {
    case 3:
      textSize(80);
      fill(255, 0, 0);
      textAlign(LEFT);
      text(review, width - reviewTextIndex, height/2);

      if (keyPressed && key != lastKey) {
        reviewTextIndex += 15;
      }
      lastKey = key;
      if (reviewTextIndex > width + textWidth(review) * 0.7) {
        continueVoiceScript = true;
      }   
      break;

    case 7: 
    case 11:
      if (child.size() < 20) {
        if (millis() - addWindowTime > addWindowInterval) {
          addWindowTime = millis();
          child.add(new ChildApplet(child.size(), true));
        }
      }

      for (int i = child.size()-1; i >= 0; i--) {
        ChildApplet ch = child.get(i);

        if (ch.mousePressed) {  
          if (ch.ID == randWindow) {
            for (int j = child.size()-1; j >= 0; j--) {
              if (j != i) {
                child.get(j).exit();
                child.remove(j);
              }
            }
            continueVoiceScript = true;
            break;
          } else {
            ch.exit();
            child.remove(i); 

            if (child.size() > 0) {
              int randombluh = (int)random(bluh.length);
              speak(bluh[randombluh]);
            }

            if (child.size() == 0) {
              continueVoiceScript = true;
            }
          }
        }
      }
      break;

    case 14: 
      if (child.get(0).foundTheCircle()) {
        continueVoiceScript = true;
      }
      break;
    }
  }

  textSize(40);
  fill(0);
  textAlign(CENTER);
  text(voiceScript[voiceScriptIndex], width/2, height-12);
}

Process speak(String text) {
  return exec("/usr/bin/say", text);
}
