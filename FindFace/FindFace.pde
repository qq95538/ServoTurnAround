import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*; //import serial for communication with MegaPi
Capture video;
OpenCV opencv;
Serial ServoPort; //Create a serial for MegaPi

int lastx = 0, lasty = 0;


void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  ServoPort = new Serial(this, Serial.list()[0], 9600); // if you have only ONE serial port active
  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  //println(faces.length);

  if(faces.length > 0){
    for (int i = 0; i < faces.length; i++) {
      //println(faces[i].x + "," + faces[i].y);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    
    if(faces[0].x != lastx || faces[0].y != lasty){
        lastx = faces[0].x; lasty = faces[0].y;
        println(lastx, lasty);
        replyServoRequest(faces[0].x, faces[0].y);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void replyServoRequest(int yaw, int roll) //send yaw and roll angel to MegaPi to control servos 
{
  int pos, pos1;
  while (ServoPort.available() > 0) {
    int inByte = ServoPort.read();
    if(inByte=='#')
    {
      pos = -int(yaw)%180;
      pos1 = -int(roll)%180+90;
      print("yaw=");
      print(pos);
      print(',');
      print("roll=");
      println(pos1);
      print(';');
      ServoPort.write('%');
      ServoPort.write(pos);
      ServoPort.write(pos1);
      break;
    }
  }
}