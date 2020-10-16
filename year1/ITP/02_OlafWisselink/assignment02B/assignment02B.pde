void setup() {
  String input = "Olrem Ipsum Placeholder Text";
  input = input.toLowerCase();
  char c = input.charAt(0);
  int input_length = input.length();
  
  int vowels = 0;
  int whitespaces = 0;
  
  // For every character in the input string
  // Check if the char is 'a', 'e', 'i', 'o' or 'u'
  // Or if it's ' '
  // Count the occurences
  for (int i = 0; i < input_length; ++i) {
    c = input.charAt(i);
    
    if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
      vowels++;
    }
    
    else if (c == ' ') {
      whitespaces++;
    }
  }
  println("The input contains", vowels, "vowels and", whitespaces, "whitespace characters.");
}

void draw() {}
