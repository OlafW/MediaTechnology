String[] voiceScript = {
  " ",
  "Hi! welcome to this Processing program", 
  "Do you like it?", 
  "Please type your experience in full detail", 
  "Ok ok, I get it....", 
  "Think you can do better?", 
  "What about now, huh? It's beautiful............",
  "Let's add some more",
  "Hey! Don't destroy my program! ", 
  "I worked so hard on that...", 
  "You asked for this... ", 
  "Now look at program ", 
  "Yes, that's the one. Amazing, don't you think?", 
  "Could be a Malevitsj.",
  "But the circle seems to be missing... Please find it",
  "Ah, there it is! Sneaky little thing.",
  "Way better now.",
  "But let's add even more...",
  "Say cheese!!",
  "Looking great there. But let's make one tiny adjustment",
  "I'm assuming you're head is over here",
  "Please clearly shout if that's the case",
  "Okay great! ....Well... that's about it, I guess",
  "...I'm running late for yoga class, so...",
  "I gotta go now. See you, bye bye!"
};

String review = "I don't really like it, tbh this is like beginner stuff. " + 
                "It could have been 2 circles easily... or a square. " +
                "And no animation? Or color? Did you even spend more than 5 minutes on this?";
  
String[] bluh = {"ba", "bluh", "poh", "huh?!", "oooooooooh", "bluh?", "oooooooh?"}; 

int randWindow = (int)random(20, 50);


void initVoiceScript() {
  voiceScript[11] += randWindow;
  voiceScript[11] += ". It's the nicest one I think";
}
