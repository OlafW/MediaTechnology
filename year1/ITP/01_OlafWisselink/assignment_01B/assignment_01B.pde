int i = 0;

void mouseClicked() {
  i++;
  int toggle = i % 2;
  println("Clicked", i, " times - Switch at ", toggle); 
  
  // increment i
  // toggle variable: get even and uneven amount of clicks with modulo 2
}
    
void draw() {
}
