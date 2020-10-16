import netP5.*;
import oscP5.*;
  
OscP5 osc;

NetAddress puredata;

void setup() {
  size(400,400);
  
  osc = new OscP5(this, 12000);
  
  // PureData address
  puredata = new NetAddress("127.0.0.1",8000);
}

void draw() {
  background(0);
  rect(mouseX, mouseY, 20,20);
}

void mouseDragged() {
  OscMessage myMessage = new OscMessage("/1/fader1");
  myMessage.add(mouseX / 400.0); /* add an int to the osc message */
    osc.send(myMessage, puredata);
    
  myMessage = new OscMessage("/1/fader2");
  myMessage.add(mouseY / 400.0); /* add an int to the osc message */
    osc.send(myMessage, puredata);
  // send 2 osc messages with address /mousex and /mousey     // when the mouse is dragged
}


void mouseMoved() {
    // send 2 osc messages with address /mousex and /mousey 
    // when the mouse is moved
  OscMessage myMessage = new OscMessage("/mouseX");
  myMessage.add(mouseX); /* add an int to the osc message */
    osc.send(myMessage, puredata);
    
  myMessage = new OscMessage("/mouseY");
  myMessage.add(mouseY); /* add an int to the osc message */
    osc.send(myMessage, puredata);
}