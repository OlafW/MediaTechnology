PImage img;
float maxFontSize = 150;
float fontSize = maxFontSize;

void setup() {
  size(800, 600);
  background(255);
  
  img = loadImage("data/painting.jpg"); 
  img.resize(width, height);
}


void keyPressed() {
  int nLetter = (int)random(1, maxFontSize-fontSize);
  int rX, rY;
  color c;
  
  textAlign(CENTER, CENTER);
  
  for (int i = 0; i < nLetter; i++) {
   rX = (int)random(width);
   rY = (int)random(height);
   
   c = img.get(rX, rY);
   fill(c);
   textSize(fontSize);
   text(key, rX, rY);
  }
  
  if (fontSize > 25) fontSize *= 0.95;
}

void draw() {}
