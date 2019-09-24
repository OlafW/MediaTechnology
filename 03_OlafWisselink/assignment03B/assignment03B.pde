void setup() {
  size(500, 500);
}

String modulus(int input) {
  // If input is divisible by 2 the remainder is 0
  // Return "even" if so, else return "odd"
  if (input % 2 == 0) return "even";
  else return "odd";
}


void draw() {
  background(255);
  
  // Make random integer
  // Print the result modulus() returns
  int r = (int)random(1000);
  println(r, "is", modulus(r));  
}
