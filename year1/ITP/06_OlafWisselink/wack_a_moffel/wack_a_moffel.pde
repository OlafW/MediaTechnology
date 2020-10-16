// Create an array of mole objects
int score = 0;
int numMole = 5;
Mole mole[] = new Mole[numMole];

PImage moffel;
PImage piertje;

void setup() {
  size(500, 500);
  
  moffel = loadImage("./data/moffel.png");
  piertje = loadImage("./data/piertje.png");
  
  // Create the mole objects
  for (int i = 0; i < numMole; i++) {
    mole[i] = new Mole();
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < numMole; i++) {
    mole[i].RandomlyReappear();
    mole[i].display();
  }
  
  // Display score
  textSize(20);
  fill(0);
  noStroke();
  text("Score: " + score, 10, 20);
}

void mousePressed() {
  // For every mole, check if we pressed it
  for (int i = 0; i < numMole; i++) {
    
    // Keep track of score
    score += mole[i].wack(mouseX, mouseY);
    
    if (score < 0) score = 0;
  }
}
