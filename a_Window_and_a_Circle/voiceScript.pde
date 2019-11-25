JSONArray voiceScript;
JSONObject voice;
String sentence = " ";
String sentenceID = " ";
int speechInterval;
long speechTime;

int voiceScriptIndex = 4;
boolean continueVoiceScript = true;

String review = "I don't really like it, tbh this is like beginner stuff. " + 
                "It could have been 2 circles easily... or a square. " +
                "And no animation? Or color? Did you even spend more than 5 minutes on this?!";
  
String[] bluh = {"ba", "bluh", "poh", "huh?!", "oooooooooh", "bluh?", "oooooooh?"}; 

int randWindow = (int)random(25, 50);
String randWindowSentence = " " + randWindow + ". It's the nicest one I think";


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
