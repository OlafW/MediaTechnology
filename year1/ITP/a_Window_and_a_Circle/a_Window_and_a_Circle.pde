/*
  Ideas for further development:
    - Make changes on the second loop: 
      - make black circle in 2nd window also clickable: different outcome?
      - make the main circle a different color and therefore different outcome
      - give narrator a deja-vu response
   - Implement the main window as being of the same class as the randWindow(s)
*/

/*
  
  A Window and a Circle
  Olaf Wisselink
  Media Technology Introduction to Programming Final Project
  December 2019
  
 -----IMPORTANT NOTE-----
 This will (probably) only work on OSX, because I'm running the terminal from within Processing.
 I haven't figured out a way to also make it work on Windows....
 
 Hi!
 This a Processing game all about windows and circles. And clicking!
 Some notes about the assignment requirements:
 - It can take slightly longer than 1 minute due to there being a narrator - max 2 minutes
 - Winning or losing is slightly vague - there are multiple outcomes though
 - This also goes for the indication of time =D
 - The ending is not really done, I want to extend the game but
   this goes beyond the assignment
 
 General structure of the program:
 The main part of the code serves to keep track of the state of the game and act accordingly
 A JSON file is read that contains the voice lines and a state ID
 The program executes actions relating to the state: play the speechline,  wait for user input, make new windows or to advance the next state, etc.
 This happens mostly in the giant switch() statements in draw()
 
*/

ArrayList<ChildApplet> child = new ArrayList<ChildApplet>();

float MINUTES = 2.0;
long TOTALTIME_MS = int(MINUTES * (1000 * 60));
long passedTime = 0;
boolean timeUp = false;
int NUMRANDWINDOWS = 0;

long addWindowTime = 0;
int addWindowInterval = 4000;
float circleDiam = 100;

Process speech;

void settings() {
  fullScreen();
}

void setup() {
  voiceScript = loadJSONArray("data/voicescript.json");
}

void draw() {    
  background(255);

  float timeMs = constrain(millis() - passedTime - 5000, 0, TOTALTIME_MS);
  float t = pow(timeMs / (float)TOTALTIME_MS, 4);  

  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = color((1.0 - t) * 255.0 + t * random(255));
  }
  updatePixels();  

  fill(0);
  noStroke();
  ellipse(width/2, height/2, circleDiam, circleDiam);

  textSize(40);
  fill(0);
  textAlign(CENTER, BOTTOM);
  text(sentence, width/2, height-5);

  if (speech == null) {
    if (millis() > 3000) {
      voice = voiceScript.getJSONObject(voiceScriptIndex);
      sentence = voice.getString("sentence");
      speech = speak(sentence);

      speechTime = millis();
      voiceScriptIndex++;
    }
  } 
  
  else {
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
          
          for (int n = 0; n < NUMRANDWINDOWS; n++) {
            speak(sentence, speakRate + (n + 1) * 30);
          }

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
            NUMRANDWINDOWS++;
            voiceScriptIndex = 0;
            passedTime = millis();
            //ChildApplet ch = child.get(0); 
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
        } 
        else {
          voiceScriptIndex = findVoiceScriptIndex("broken");
          continueVoiceScript = true;
          addWindowInterval = 4000;
          break;
        }

        if (child.size() == NUMRANDWINDOWS) {
          addWindowInterval = 4000;
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

      if (millis() - passedTime > TOTALTIME_MS && !timeUp) {
        continueVoiceScript = true;
        timeUp = true;

        if (voiceScriptIndex <= findVoiceScriptIndex("secondClick")) {
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
