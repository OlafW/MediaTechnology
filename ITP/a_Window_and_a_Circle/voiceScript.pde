int voiceScriptIndex = 0;
boolean continueVoiceScript = true;

int speechInterval;
long speechTime;
int speakRate = 195;

int randWindow = (int)random(25, 50);

JSONArray voiceScript;
JSONObject voice;
String sentence = " ";
String sentenceID = " ";

Process speak(String text) {
  return exec("/usr/bin/say", text, "-r " + speakRate);
}

Process speak(String text, int rate) {
  return exec("/usr/bin/say", text, "-r " + rate);
}

int findVoiceScriptIndex(String ID) {
  JSONObject sentence;
  int scriptIndex = -1;
  
  for (int i = 0; i < voiceScript.size(); i++) {
    sentence = voiceScript.getJSONObject(i);
    
    if (sentence.getString("ID").equals(ID)) {
      scriptIndex = i;
      break;
    }
  }
  return scriptIndex;
}
  
String[] bluh = {"ba", "bluh", "poh", "huh?!", "oooooooooh", "bluh?", "oooooooh?"}; 
String randWindowSentence = " " + randWindow + ". Should be here somewhere";
