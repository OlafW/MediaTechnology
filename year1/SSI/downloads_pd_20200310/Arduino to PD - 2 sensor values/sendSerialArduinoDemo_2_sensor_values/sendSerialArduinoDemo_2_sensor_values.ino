//DEMO for sending data from arduino to pure data through serial communication.
//Note: here Serial.write() is used. This writes binary data to the serial port. The numbers you can send are limited to a range of 0 - 255. If you need to send bigger values look at this tutorial: https://www.arduino.cc/en/Tutorial/SerialCallResponseASCII

long unsigned currentMillis, previousMillis = 0;
int interval = 100;
int i, j, k, l = 0; //i and j representthe two sensor values that are being sent.
int lowerTwoDigits, higherTwoDigits = 0;

void setup() {
  //Start serial connection
 Serial.begin(9600);
}

void loop() {
  currentMillis = millis();
  if (currentMillis - previousMillis >= interval){
    Serial.write(255); //send the value 255 to indicate that we are sending a set of new values. The PD patch uses this to synchronize to the data.
    i = i + 1;
    i = i % 1024;
    lowerTwoDigits =  i % 100;
    higherTwoDigits =  i / 100;
    Serial.write(lowerTwoDigits);
    Serial.write(higherTwoDigits);

    j++;
    j++;
    j++;
    j = j % 1024;
    lowerTwoDigits = j % 100;
    higherTwoDigits = j / 100;
    Serial.write(lowerTwoDigits);
    Serial.write(higherTwoDigits);
    
    k++;
    k++;
    k++;
    k++;
    k++;
    k++;
    k = k % 1024;
    lowerTwoDigits = k % 100;
    higherTwoDigits = k / 100;
    Serial.write(lowerTwoDigits);
    Serial.write(higherTwoDigits);
    
    l++;
    l++;
    l = l % 1024;
    lowerTwoDigits = l % 100;
    higherTwoDigits = l / 100;
    Serial.write(lowerTwoDigits);
    Serial.write(higherTwoDigits);

   
    previousMillis = currentMillis;
  }
}
