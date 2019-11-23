import processing.video.*;

ArrayList<ChildApplet> child = new ArrayList<ChildApplet>();

long addWindowTime = 0;
int addWindowInterval = 4000;
char lastKey = ' ';
int reviewTextIndex = 0;

Capture video;

Process speech;

void settings() {
  fullScreen();
}

void setup() {
  fullScreen();
  voiceScript = loadJSONArray("data/voicescript.json");
}

void draw() {
  background(255);

  fill(0);
  noStroke();
  ellipse(width/2, height/2, 75, 75);

  if (speech == null) {
    if (millis() > 3000) {
      sentence = voiceScript.getJSONObject(voiceScriptIndex);
      line = sentence.getString("line");
      speech = speak(line);
      
      speechTime = millis();
      voiceScriptIndex++;
    }
  } 
  
  else {
    if (continueVoiceScript) {
      if (!speech.isAlive()) {

        if (millis() - speechTime > speechInterval) {
          speechTime = millis();

          sentence = voiceScript.getJSONObject(voiceScriptIndex);
          ID = sentence.getString("ID");
          line = sentence.getString("line");
          speechInterval = sentence.getInt("time");
          
          if (ID.equals("findWindow")) {
            line += randWindowSentence;
          }     
          speech = speak(line);
          
          if (voiceScriptIndex < voiceScript.size()-1) {
            voiceScriptIndex++;
          }

          int numWindows = 0;

          switch(ID) {
          case "review":
            continueVoiceScript = false;
            break;

          case "firstWindows":
            numWindows = 5;

            for (int i = 0; i < numWindows; i++) {
              child.add(new ChildApplet(child.size(), false));
            }
            break;

          case "secondWindows":
            numWindows = 50;

            child.clear();
            for (int i = 0; i < numWindows; i++) {
              child.add(new ChildApplet(child.size(), false));
            }
            break;

          case "clickWindows":
          case "findWindow":
            continueVoiceScript = false;
            break;
            
          case "findCircle":
            child.get(0).getSurface().setResizable(true);
            continueVoiceScript = false;
            break;

          case "camera":
            child.get(0).getSurface().setResizable(false);
            child.get(0).getSurface().setSize(512, 512);
            child.get(0).getSurface().setLocation((int)displayWidth/2-256, (int)displayHeight/2-256);
            child.get(0).startVideo();
            break;
                    
         case "ending":
           exit();
         
          }
        }
      }
    }

    if (!speech.isAlive()) {    
      switch(ID) {

      case "review":
        textSize(80);
        fill(255, 0, 0);
        textAlign(LEFT);
        text(review, width - reviewTextIndex, height/2);

        if (keyPressed && key != lastKey) {
          reviewTextIndex += 15;
        }
        lastKey = key;
        if (reviewTextIndex > width + textWidth(review) * 0.55) {
          continueVoiceScript = true;
        }   
        break;

      case "clickWindows": 
      case "findWindow":
      
        if (child.size() < 20) {

          if (millis() - addWindowTime > addWindowInterval) {
            addWindowTime = millis();
            child.add(new ChildApplet(child.size(), true));
            if (addWindowInterval > 750) addWindowInterval *= 0.9;
            else addWindowInterval = 4000;
          }
        }

        for (int i = child.size()-1; i >= 0; i--) {
          ChildApplet ch = child.get(i);

          if (ch.mousePressed || ch.getSurface().isStopped()) {  
            if (ch.ID == randWindow) {
              for (int j = child.size()-1; j >= 0; j--) {
                if (j != i) {
                  child.get(j).exit();
                  child.remove(j);
                }
              }
              continueVoiceScript = true;
              break;
            } 
            
            else {
              ch.exit();
              child.remove(i); 

              if (child.size() > 0) {
                int randombluh = (int)random(bluh.length);
                speak(bluh[randombluh]);
              }
            }
          }
        }
        if (child.size() == 0) {
          continueVoiceScript = true;
        }
        break;

      case "findCircle": 
        if (child.get(0).foundCircle()) {
          continueVoiceScript = true;
        }
        break;
      }
    }
  }

  textSize(40);
  fill(0);
  textAlign(CENTER);
  text(line, width/2, height-12);
}

Process speak(String text) {
  return exec("/usr/bin/say", text);
}
