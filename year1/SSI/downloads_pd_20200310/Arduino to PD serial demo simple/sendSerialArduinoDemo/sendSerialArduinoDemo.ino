//DEMO for sending data from arduino to pure data through serial communication.
//Note: here Serial.write() is used. This writes binary data to the serial port. The numbers you can send are limited to a range of 0 - 255. If you need to send bigger values look at this tutorial: https://www.arduino.cc/en/Tutorial/SerialCallResponseASCII

long unsigned previousMillis = 0;
int interval = 100;
int i = 0;

void setup() {
  //Start serial connection
 Serial.begin(9600);
  //configure pin2 as an input and enable the internal pull-up resistor for the push button
 pinMode(2, INPUT_PULLUP);
 pinMode(13, OUTPUT);
}

void loop() {
  //read the pushbutton value into a variable
  int sensorVal = digitalRead(2);

  //LINEARLY INCREASE i FROM 0 TO 253 
  long unsigned currentMillis = millis();
  if (currentMillis - previousMillis >= interval){
    i++;
    i = i % 253; //Modulo is used to make i repeatedly increase from 0 to 252
    Serial.write(i);
    previousMillis = currentMillis;
  }

  //USE PUSHBUTTON TO TOGGLE VOLUME IN PD
  // Keep in mind the pullup means the pushbutton's
  // logic is inverted. It goes HIGH when it's open,
  // and LOW when it's pressed. Turn on pin 13 when the
  // button's pressed, and off when it's not:
  if (sensorVal == HIGH) {
    //Send a value of 254 to PD
    Serial.write(254);
    //Switch off onboard led
    digitalWrite(13, LOW);
  } else {
    //Send a value of 255 to PD
    Serial.write(255);
    //Switch on onboard led
    digitalWrite(13, HIGH);
  } 
}
