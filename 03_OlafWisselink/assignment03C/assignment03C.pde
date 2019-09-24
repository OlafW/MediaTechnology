String results[] = {"YOU LOSE", "DRAW", "YOU WIN!!!!1!"};
boolean keyReleased = true;

void setup() {
  size(128, 128);
}

void keyPressed() {
  // Did we type one of the right keys?
  if ((key == 'r' || key == 'p' || key == 's') && keyReleased) {
    String player = "";
    String computer = "";
    boolean win = false;
    
    // See which key we typed and set player
    if (key == 'r') player = "rock";
    else if (key == 'p') player = "paper";
    else if (key == 's') player = "scissors";
    
    // computer makes a move
    computer = randomRockPaperScissors();

    // Is it a draw?
    if (player.equals(computer)) {
      println("Player:", player, "-- VS -- CPU:", computer, "---- DRAW");
    }    
    
    // Else, check if we won or lost for each case
    else {
      // player = rock
      if (player.equals("rock")) {
        if (computer.equals("scissors")) win = true;
        else win = false; 
      }
      
      // player = paper
      else if (player.equals("paper")) {
        if (computer.equals("rock")) win = true;
        else win = false; 
      }
      
      // player = scissors
      else if (player.equals("scissors")) {
        if (computer.equals("paper")) win = true;
        else win = false;
      }
      
      if (win) println("Player:", player, "-- VS -- CPU:", computer, "---- YOU WIN!!!!1!!");
      else println("Player:", player, "-- VS -- CPU:", computer, "---- YOU LOSE");
    }
  }
  keyReleased = false;
}


String randomRockPaperScissors() {
  // Make random integer
  // Return string according to int
  int r = (int)random(3);
  
  if (r == 0) return "rock";
  else if (r == 1) return "paper";
  else return "scissors";
}

void keyReleased() {
  // holding a key triggers it just once
  keyReleased = true;
}


void draw() {
  background(255);
}
