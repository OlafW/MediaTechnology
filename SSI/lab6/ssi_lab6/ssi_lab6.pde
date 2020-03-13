import netP5.*;
import oscP5.*;

/*
  This Processing sketch draws a Lissajous figure, 
  a figure made out of two sinusoid waves that describe x and y position.
  The frequencies are send to Pd and are there synthesized.
  Problem: animation and sound run out of phase when modulating 
  frequency for some reason.
*/

OscP5 osc;
NetAddress toPd;
int oscTimeInterval = 500;
long passedTime = 0; 
long tstart = 0;

// x & y frequencies in Hz
float xfreq = 220.0; 
float yfreq = xfreq * 1.5;
float xamp, yamp;

// x & y modulation
float xmodf = 0.025;
float ymodf = 0.001;
float xmodamp = 0.0;
float ymodamp = 4.0;

float t = 0;
float dt = 0;
int numPoints = 250;

void setup() {
  size(600, 600);
  
  // start oscP5, receive messages on port 12000
  osc = new OscP5(this, 12000);
  // Send messages to localhost on port 8000
  toPd = new NetAddress("127.0.0.1", 8000);
  
  xamp = width * 0.45;
  yamp = height * 0.45;
  
  // speed factor of animation
  dt = 1.0 * (1.0 / (numPoints * frameRate));
  
  OscMessage message = new OscMessage("/xy-freq");
  message.add(xfreq);
  message.add(yfreq);
  osc.send(message, toPd);
  
  message = new OscMessage("/xy-mod"); 
  message.add(xmodf);
  message.add(xmodamp);
  message.add(ymodf);
  message.add(ymodamp);
  osc.send(message, toPd);
  
  message = new OscMessage("/phase");
  message.add(0);
  osc.send(message, toPd);
  
  tstart = millis();
}

void draw() {
  background(255);
  translate(width/2, height/2);
  
  beginShape();
  noFill();
  stroke(0);
  strokeWeight(2);
  
  t = (millis() - tstart) * 0.001;
  
  float x, y;
  float xmod, ymod;
  
  xmod = cos(TWO_PI * t * 0.5*xmodf) * xmodamp;
  ymod = sin(TWO_PI * t * 0.5*ymodf) * ymodamp;
    
  for (int i = 0; i < numPoints; i++) {  
    x = cos(TWO_PI * t * (xfreq + xmod)) * xamp;
    y = sin(TWO_PI * t * (yfreq + ymod)) * yamp;
    
    t += dt;
    curveVertex(x, y); 
  }
  endShape();
}


// To receive messages back from Pd 
// Not using this now
void oscEvent(OscMessage message) {
  
  float ntp = 0.0; // linear interpolation factor (0-1)
  
  if (message.checkAddrPattern("/xy-modfreq")) {
    if (message.checkTypetag("ff")) {
      //xmodf = ntp * xmodf + (1.0 - ntp) * message.get(0).floatValue();  
      //ymodf = ntp * ymodf + (1.0 - ntp) * message.get(1).floatValue();  
    }
    else if (message.checkTypetag("ii")) {
      //xmodf = ntp * xmodf + (1.0 - ntp) * message.get(0).intValue();  
      //ymodf = ntp * ymodf + (1.0 - ntp) * message.get(1).intValue();  
    }
  }
}
