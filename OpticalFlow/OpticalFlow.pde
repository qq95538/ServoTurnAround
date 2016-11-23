import gab.opencv.*;
import processing.video.*;
import processing.serial.*;
Serial port;

OpenCV opencv;
//Movie video;
Capture video;

void setup() {
  size(640, 240);
  port = new Serial(this, Serial.list()[0], 9600);
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);  
  video.start();
}

void draw() {
  background(0);
  opencv.loadImage(video);
  opencv.calculateOpticalFlow();
  image(video, 0, 0);
  translate(video.width,0);
  stroke(255,0,0);
  opencv.drawOpticalFlow();
  PVector aveFlow = opencv.getAverageFlow();
  int flowScale = 50; 
  stroke(255);
  strokeWeight(2);
  line(video.width/2, video.height/2, video.width/2 + aveFlow.x*flowScale, video.height/2 + aveFlow.y*flowScale);
  replyServoRequest(int(aveFlow.x*1000), int(aveFlow.y*1000));
  //print(int(aveFlow.x*1000));
  //print("|");
  //println(int(aveFlow.y*1000));
}

void captureEvent(Capture c) {
  c.read();
}

void replyServoRequest(int x, int y) //send yaw and roll angel to MegaPi to control servos 
{
  while (port.available() > 0) {
    int inByte = port.read();
    if(inByte=='#')
    {
      print("x=");
      print(x);
      print(',');
      print("y=");
      print(y);
      println(';');
      port.write('%');
      port.write(x);
      port.write(y);
      break;
    }
  }
}