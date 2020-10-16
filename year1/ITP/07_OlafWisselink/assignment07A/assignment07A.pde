boolean playerTurn = false;
String[] moveList = { "L" };
String setMove;
int movePointer = 0;
int timer = 80;

void setup() {
  size(512, 512);
  movePointer = 0;
}


void draw() {
  background(255);

  if (playerTurn) {
    
    if (keyPressed) {
      switch(keyCode) {
      case LEFT:
        setMove = "L";
        makeMove("L");
        break;
      case RIGHT:
        setMove = "R";
        makeMove("R");
        break;
      }
    }
    
  } else {
    timer--;

    if (timer > 20 && timer < 80) {
      // Only show Simon's move for part of the timer
      makeMove( moveList[movePointer] );
    }

    if (timer <= 0) {
      if (movePointer < moveList.length-1) {
        movePointer++;
        timer = 80;
      } else {
        movePointer = 0;
        playerTurn = true;
        timer = 120;
      }
    }
  }
}



void makeMove (String move) {
  noStroke();
  if (move == "L") {
    fill(#7BB4EA);
    rect(0, 0, width/2, height);
  } else if (move == "R") {
    fill(#EA7BE5);
    rect(width/2, 0, width, height);
  }
}

void keyReleased() {
  if (playerTurn) {
    if (moveList[movePointer] == setMove) {
      println("CORRECT");
      
      if (movePointer < moveList.length-1) {
        movePointer++;
      } else {
        println("----Adding a new move, now", moveList.length+1, "moves----");
        
        // Make a new array of current size + 1
        String[] copyMoves = new String[moveList.length + 1];
                    
        // Copy all the current moves to the new array
        for (int i = 0; i < moveList.length; i++) {
           copyMoves[i] = moveList[i];
        }
        
        // Make a random move
        String randMove = (random(1) < 0.5) ? "L" : "R";
        
        // Add the new random move at the end
        copyMoves[copyMoves.length-1] = randMove;
        
        // Set the moveList array to new array
        moveList = copyMoves;
        
        movePointer = 0;
        playerTurn = false;
      }
      
    } else {
      println("WROOONG");
      moveList = new String[] { "L" };
      movePointer = 0;
      playerTurn = false;
    }
  }
}
