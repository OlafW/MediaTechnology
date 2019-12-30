JSONArray voiceScript;
JSONObject voice;
String sentence = " ";
String sentenceID = " ";
int speechInterval;
long speechTime;

int voiceScriptIndex = 0;
boolean continueVoiceScript = true;
int randWindow = (int)random(25, 50);
int speakRate = 195;

Process speak(String text) {
  return exec("/usr/bin/say", text, "-r " + speakRate);
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
