import gab.opencv.*;
import processing.video.*;
import processing.serial.*;
Serial port;

OpenCV opencv;
Capture video;
byte lastx, lasty;
byte currentx, currenty;
byte[] rawVecX;
byte[] rawVecY;
int index;
int count;
boolean action;
final int sampleNbr = 20;

void setup() {
  size(640, 240);
  rawVecX = new byte[sampleNbr];
  rawVecY = new byte[sampleNbr];
  lastx = 0;
  lasty = 0;
  count = 0;
  port = new Serial(this, Serial.list()[0], 115200);
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
  currentx=byte(map(aveFlow.x, -1, 1, 0, 255));
  currenty=byte(map(aveFlow.y, -1, 1, 0, 255));
  if (action == true){
      if(index < sampleNbr){
          rawVecX[index] = currentx;
          rawVecY[index] = currenty;
          index++;  
      }
      else
      {
          action = false; 
          print("count=");
          println(count); 
          for(int i = 0; i < sampleNbr; i++){
              print(int(rawVecX[i]));
              print(",");
          }
          println();
          for(int i = 0; i < sampleNbr; i++){
              print(int(rawVecY[i]));
              print(",");
          }
          println("|");
          sendToCurie(true, rawVecX, rawVecY);
          println("accepted");
       }
  }
  else
  {
    if(abs(int(currentx)-int(lastx)) > 30 || abs(int(currenty)-int(lasty)) > 30){
      action = true;
      index = 0;
      count = count + 1;
      println("started");
      //println(int(currentx)-int(lastx));
      //println(int(currenty)-int(lasty));
    }
  }
  lastx = currentx;
  lasty = currenty;

}

void captureEvent(Capture c) {
  c.read();
}

void sendToCurie(boolean LorC, byte[] vecX, byte[] vecY) //send yaw and roll angel to MegaPi to control servos 
{
   if(LorC == true){
        port.write('%');        
   }
   else{
        port.write('$');
   }
      
  port.write(vecX);
  port.write(vecY);
  
  byte inByte;
  while (port.available() > 0){
      inByte = byte(port.read());
      print(int(inByte));
      print(">");
      if(inByte == '#'){
          break;
      }
  }
}