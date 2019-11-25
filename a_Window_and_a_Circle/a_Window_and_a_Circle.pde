import processing.video.*;
import processing.sound.*;

ArrayList<ChildApplet> child = new ArrayList<ChildApplet>();

long MINUTES = 4 * (1000 * 60);

long addWindowTime = 0;
int addWindowInterval = 4000;
char lastKey = ' ';
int reviewTextIndex = 0;

Capture video;
AudioIn mic;
Amplitude amp;

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
          
          if (voiceScriptIndex < voiceScript.size()-1) {
            voiceScriptIndex++;
          }

          int numWindows = 0;

          switch(sentenceID) {
          case "firstWindows":
            numWindows = 5;

            for (int i = 0; i < numWindows; i++) {
              child.add(new ChildApplet(child.size(), false));
            }
            break;

          case "secondWindows":
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

          case "camera":
            ChildApplet ch = child.get(0);   
            ch.getSurface().setResizable(false);
            ch.getSurface().setSize(512, 512);
            ch.getSurface().setLocation((int)displayWidth/2-256, (int)displayHeight/2-256);
            ch.startVideo();
            break;
            
         case "shoutCircle":
           child.get(0).startAudio();
           continueVoiceScript = false;
           break;
          
         case "review":
         case "clickWindows": case "findWindow":           
         case "ending": case "restart":
           continueVoiceScript = false;
             break;
          }
        }
      }
    }

    if (!speech.isAlive()) {               
      switch(sentenceID) {   
        
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
        if (child.size() < 25) {
          if (millis() - addWindowTime > addWindowInterval) {
            addWindowTime = millis();
            child.add(new ChildApplet(child.size(), true));
            if (addWindowInterval > 500) addWindowInterval *= 0.9;
          }
        }
        else {
          voiceScriptIndex = findVoiceScriptIndex("brokeVoice");
          continueVoiceScript = true;
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
        
      case "shoutCircle": 
        if (child.get(0).circleOffScreen()) {
          continueVoiceScript = true;
        }
        break;
        
       case "ending": case "restart":
         exit();
         break;
      }
    
     if (millis() > MINUTES) {
      if (voiceScriptIndex < findVoiceScriptIndex("findWindow")) {
        voiceScriptIndex = findVoiceScriptIndex("tooLong");
        continueVoiceScript = true;
      }
    }
    
    for (int i = child.size()-1; i >= 0; i--) {
      ChildApplet ch = child.get(i);
        
      if (ch.getSurface().isStopped()) {
        if (ch.ID == randWindow) {
          voiceScriptIndex = findVoiceScriptIndex("broken");
          continueVoiceScript = true;
        }
        child.remove(i); 
      }
    }
   }
  }
 
  textSize(40);
  fill(0);
  textAlign(CENTER);
  text(sentence, width/2, height-12);
}
