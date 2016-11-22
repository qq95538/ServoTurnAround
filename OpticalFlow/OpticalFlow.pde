import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
//Movie video;
Capture video;

void setup() {
  size(640, 240);
  //video = new Movie(this, "sample1.mov");
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  //video.loop();
  //video.play();  
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
}

//void movieEvent(Movie m) {
//  m.read();
//}

void captureEvent(Capture c) {
  c.read();
}