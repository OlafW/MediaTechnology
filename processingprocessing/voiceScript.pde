JSONArray voiceScript;
JSONObject voice;
String sentence = " ";
String sentenceID = " ";
int speechInterval;
long speechTime;

int voiceScriptIndex = 0;
boolean continueVoiceScript = true;

String review = "I don't really like it, tbh this is like beginner stuff. " + 
                "It could have been 2 circles easily... or a square. " +
                "And no animation? Or color? Did you even spend more than 5 minutes on this?!";
  
String[] bluh = {"ba", "bluh", "poh", "huh?!", "oooooooooh", "bluh?", "oooooooh?"}; 

int randWindow = (int)random(20, 50);
String randWindowSentence = " " + randWindow + ". It's the nicest one I think";
