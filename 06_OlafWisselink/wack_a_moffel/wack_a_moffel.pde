int score = 0;
int numMole = 5;
Mole mole[] = new Mole[numMole];

PImage moffel;
PImage piertje;

void setup() {
  size(500, 500);
  
  moffel = loadImage("./data/moffel.png");
  piertje = loadImage("./data/piertje.png");
  
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
  
  textSize(20);
  fill(0);
  noStroke();
  text("Score: " + score, 10, 20);
}

void mousePressed() {
  for (int i = 0; i < numMole; i++) {
    score += mole[i].wack(mouseX, mouseY);
    
    if (score < 0) score = 0;
  }
}
