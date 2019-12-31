/*

 Hi!
 This is a unfinished (but working) Processing game
 It's all about windows and circles!
 Some notes about the assignment requirements:
 - It takes slightly longer than 1 minute due to there being a narrator - max 2 minutes
 - Winning or losing is slightly vague - there are multiple outcomes though
 - This also goes for the indication of time =D
 */

ArrayList<ChildApplet> child = new ArrayList<ChildApplet>();

float MINUTES = 2.0;
long TOTALTIME = int(MINUTES * (1000 * 60));
long passedTime = 0;
boolean timeUp = false;

long addWindowTime = 0;
int addWindowInterval = 4000;
float circleDiam = 100;

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

  float timeMs = constrain(millis() - passedTime - 5000, 0, TOTALTIME);
  float t = pow(timeMs / (float)TOTALTIME, 4);  

  loadPixels();
  float noise = 0.0;
  for (int i = 0; i < pixels.length; i++) {
    noise = (1.0 - t) * 255.0 + t * random(255);
    pixels[i] = color(noise);
  }
  updatePixels();  

  fill(0);
  noStroke();
  ellipse(width/2, height/2, circleDiam, circleDiam);

  textSize(40);
  fill(0);
  textAlign(CENTER);
  text(sentence, width/2, height-24);

  if (speech == null) {
    if (millis() > 3000) {
      voice = voiceScript.getJSONObject(voiceScriptIndex);
      sentence = voice.getString("sentence");
      speech = speak(sentence);

      speechTime = millis();
      voiceScriptIndex++;
    }
  } else {
    if (continueVoiceScript) {
      if (!speech.isAlive()) {

        if (millis() - speechTime > speechInterval) {
          speechTime = millis();

          voice = voiceScript.getJSONObject(voiceScriptIndex);
          sentenceID = voice.getString("ID");
          sentence = voice.getString("sentence");
          speechInterval = voice.getInt("time");

          if (sentenceID.equals("findWindow")) {
            sentence += randWindowSentence;
          }     

          speech = speak(sentence);

          if (voiceScriptIndex < voiceScript.size()-1) {
            voiceScriptIndex++;
          }

          int numWindows = 0;

          switch(sentenceID) {
          case "firstClick":
            numWindows = 5;

            for (int i = 0; i < numWindows; i++) {
              child.add(new ChildApplet(child.size(), false));
            }
            break;

          case "secondClick":
            numWindows = 50;

            child.clear();
            child.add(new ChildApplet(randWindow, false));

            for (int i = 0; i < numWindows; i++) {
              if (i != randWindow) {
                child.add(new ChildApplet(i, false));
              }
            }
            break;

          case "findCircle":
            child.get(0).getSurface().setResizable(true);
            continueVoiceScript = false;
            break;

          case "thirdClick":
            ChildApplet ch = child.get(0); 
            //child.get(0).ID = -1;
            voiceScriptIndex = 0;
            passedTime = millis();
            break;

          case "clickWindows": 
          case "findWindow":           
          case "restart":
          case "dontClick1": 
          case "dontClick2":
          case "clickCircle":
            continueVoiceScript = false;
            break;
          }
        }
      }
    }

    if (!speech.isAlive()) {               
      switch(sentenceID) {   

      case "clickWindows": 
        if (addWindowInterval > 500) {
          if (millis() - addWindowTime > addWindowInterval) {
            addWindowTime = millis();
            child.add(new ChildApplet(child.size(), true));

            addWindowInterval *= 0.8;
          }
        } else {
          voiceScriptIndex = findVoiceScriptIndex("broken");
          continueVoiceScript = true;
          break;
        }

        if (child.size() == 0) {
          continueVoiceScript = true;
        }  
        break;

      case "findWindow":
        for (int i = 0; i < child.size(); i++) {
          if (child.get(i).ID == randWindow) {
            if (child.get(i).mousePressed) {
              continueVoiceScript = true;
              break;
            }
          }
        }
        break;

      case "findCircle": 
        if (child.get(0).foundCircle()) {
          continueVoiceScript = true;
        }
        break;

      case "clickCircle":
        if (child.get(0).clickedCircle) {
          continueVoiceScript = true;
        }
        break;

      case "stopProgram": 
      case "restart":
        exit();
        break;
      }

      boolean removedRandWindow = false;
      ChildApplet tempWin = null;

      for (int i = child.size()-1; i >= 0; i--) {
        ChildApplet ch = child.get(i);

        if (ch.getSurface().isStopped()) {
          if (ch.ID == randWindow) {
            removedRandWindow = true;
            tempWin = ch;
          }
          child.remove(i); 
          break;
        }
      }
      if (removedRandWindow) {
        ChildApplet ch = new ChildApplet(tempWin.ID, false);
        ch.getSurface().setSize(tempWin.width, tempWin.height);
        ch.getSurface().setResizable(true);
        ch.beginWindowWidth = tempWin.beginWindowWidth;
        ch.foundRandWindow = true;
        child.add(ch);
      }

      if (millis() - passedTime > TOTALTIME && !timeUp) {
        continueVoiceScript = true;
        timeUp = true;
        
        if (voiceScriptIndex < findVoiceScriptIndex("secondClick")) {
          voiceScriptIndex = findVoiceScriptIndex("didNotClick");
        }
        else {
          voiceScriptIndex = findVoiceScriptIndex("tooLong");
        }
      }
    }
  }
}

void mousePressed() {
  if (speech != null) {
    if (!speech.isAlive()) {

      switch(sentenceID) {
      case "dontClick1":
      case "dontClick2":

        float dist = dist(mouseX, mouseY, width/2, height/2);
        if (dist < circleDiam * 0.5) {
          continueVoiceScript = true;
          break;
        }
      }
    }
  }
}
