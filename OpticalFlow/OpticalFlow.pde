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
byte state;
byte[] result;
int P_result;

void setup() {
  size(640, 240);

  result = new byte[3];
  P_result = 0;
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
  if(keyPressed){
     if (key == 'a' || key == 'A') {
       state = 1;
       println("change state to learning 1");
     } 
     else if (key == 's' || key == 'S') {
       state = 2;
       println("change state to learning 2");;
       
     }
     else{
       state = 3;
       println("change state to classifying");
     }
  }
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
  
  textSize(50);
  if(result[2] == 1){    
    text("Yes", 10, 230);
  }
  else if(result[2] == 2){
    text("No", 10, 230);  
  }
  else{
    text("?", 10, 230);
  }
  textSize(40);
  if(result[1] == 1){    
    text("Yes", 10, 175);
  }
  else if(result[1] == 2){
    text("No", 10, 175);  
  }
  else{
    text("?", 10, 175);
  }
  textSize(30);
  if(result[0] == 1){    
    text("Yes", 10, 130);
  }
  else if(result[0] == 2){
    text("No", 10, 130);  
  }
  else{
    text("?", 10, 130);
  }
  
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
          print("|");
          println(state);
          sendToCurie(state, rawVecX, rawVecY);
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
    }
  }
  lastx = currentx;
  lasty = currenty;

}

void captureEvent(Capture c) {
  c.read();
}

void sendToCurie(byte LorC, byte[] vecX, byte[] vecY) //send yaw and roll angel to MegaPi to control servos 
{
   if(LorC == 1){
        port.write('%');        
   }
   else if(LorC == 2){
        port.write('^');
   }
   else{
        port.write('$');
   }
      
  port.write(vecX);
  port.write(vecY);
  
  byte inByte;
  int ct = 0;
  while (port.available() > 0){
      inByte = byte(port.read());
      print(int(inByte));
      if(ct == 0){
        result[0] = result[1];
        result[1] = result[2];
        result[2] = inByte;
      }
      print(">");
      if(inByte == '#'){
          break;
      }
      ct = ct + 1;
  }
}