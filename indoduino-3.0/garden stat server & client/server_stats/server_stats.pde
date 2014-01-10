import processing.serial.*;
import processing.net.*;
import ipcapture.*;

IPCapture cam;


int port = 9997;
Serial myPort;        // The serial port
int xPos = 51;         // horizontal position of the graph
int ypos = 8;
Server myServer;

void setup () {
  // set the window size:
  size(800, 300); 
  
   cam = new IPCapture(this, "http://173.174.93.185:8081", "", "");
  cam.start();
  
  textFont(createFont("SanSerif", 8));
  myServer = new Server(this, port);
  // List all the available serial ports
  println(Serial.list());
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 57600);
  // set inital background:
  background(0);
  frameRate(1); // Slow it down a little
}

void draw () {
/* 
  stroke(100, 255, 50);
  line(50, 250, 50, 200);
  line(50, 200, 750, 200);
  line(50, 250, 750, 250);
  line(750, 250, 750, 200);
  */
  
  if (cam.isAvailable()) {
    cam.read();
    image(cam,300,50);
  
}        



void serialEvent (Serial myPort) {
  
    stroke(100, 255, 50);
  line(50, 250, 50, 200);
  line(50, 200, 750, 200);
  line(50, 250, 750, 250);
  line(750, 250, 750, 200);

  
  myServer.write("HTTP/1.1 200 OK");
    myServer.write("Content-type:text/html");
    myServer.write("Connection: close");
    myServer.write("Refresh: 10");
    myServer.write("<!DOCTYPE HTML>");
    myServer.write("<html>");
    myServer.write("</html>");
   
    
  
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    
    myServer.write(inString);
   // myServer.write("\r \n");
    noFill();
    stroke(100, 255, 50);
    rect(51, 51, 224, 124);
    fill(255);
    text(inString, 52, ypos * 7);
    //if(ypos > 175) {
    ypos++;
    // trim off any whitespace:
    inString = trim(inString);
    // convert to an int and map to the screen height:
    float inByte = float(inString); 
    inByte = map(inByte, 0, 50, 50, 0);
    // draw the line:
    if (inByte >= 24) {
      stroke(127, 34, 255);
    }
    else { 
      stroke(255, 0, 0);
    }
    line(xPos, 250, xPos, 200 + inByte);
    // at the edge of the screen, go back to the beginning:
    if (xPos >= 749) {
      xPos = 51;
      background(0);
    } 
    else if (inByte > 0) {
      // increment the horizontal position:
      xPos++;
      //delay(500);
      ypos = 9;
      fill(0);
      stroke(100, 255, 50);
      rect(51, 51, 224, 124);
    }
  }
  
  
}


