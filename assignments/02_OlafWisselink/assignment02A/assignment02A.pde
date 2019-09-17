void setup() {
  int counter = 0;
  int target = (int)random(100);
  int guess = (int)random(100);
  
  int counter_max = 50;
  
  // Randomly guess the target number until its correct
  // Increment counter for every try
  while (guess != target) {
    guess = (int)random(100);
    counter++;
  }
  
  // If amount of tries <= maximum amount of tries: win
  if (counter <= counter_max) {
    println("Computer: Got it! It took me only", counter, "tries to find the target number", target);
  }
  // Else: lose
  else {
    println("Computer: I lost - it took me", counter, "tries to find the target number", target);
  }
}

void draw() {}
