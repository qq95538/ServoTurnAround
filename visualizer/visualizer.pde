import processing.serial.*;
Serial IMUSensorPort, ServoPort;

float yaw = 0.0;
float pitch = 0.0;
float roll = 0.0;

int pos, pos1;
boolean need_serial = false;

void setup()
{
  size(1440, 900, P3D);

  // if you have only ONE serial port active
  IMUSensorPort = new Serial(this, Serial.list()[0], 9600); // if you have only ONE serial port active
  ServoPort = new Serial(this, Serial.list()[1], 9600); // if you have only ONE serial port active
  // if you know the serial port name
  //myPort = new Serial(this, "COM5:", 9600);                    // Windows
  //myPort = new Serial(this, "/dev/ttyACM0", 9600);             // Linux
  //myPort = new Serial(this, "/dev/cu.usbmodem1217321", 9600);  // Mac

  textSize(16); // set text size
  textMode(SHAPE); // set text mode to shape
}
void mouseMoved()
{
  
}
void draw()
{
  readIMU();  // read and parse IMU sensor incoming serial message
  background(255); // set background to white
  lights();

  translate(width*0.3, height*0.65); // set position to centre

  pushMatrix(); // begin object
  float c1 = cos(radians(roll));
  float s1 = sin(radians(roll));
  float c2 = cos(radians(pitch));
  float s2 = sin(radians(pitch));
  float c3 = cos(radians(yaw));
  float s3 = sin(radians(yaw));
  applyMatrix( c2*c3, s1*s3+c1*c3*s2, c3*s1*s2-c1*s3, 0,
               -s2, c1*c2, c2*s1, 0,
               c2*s3, c1*s2*s3-c3*s1, c1*c3+s1*s2*s3, 0,
               0, 0, 0, 1);
  drawGlasses();
  popMatrix(); // end of object
  translate(width*0.4, 0); // set position to centre
  pushMatrix(); // begin object
  applyMatrix( c2*c3, s1*s3+c1*c3*s2, c3*s1*s2-c1*s3, 0,
               -s2, c1*c2, c2*s1, 0,
               c2*s3, c1*s2*s3-c3*s1, c1*c3+s1*s2*s3, 0,
               0, 0, 0, 1);
  drawCamera();

  popMatrix(); // end of object
  
  // Print values to console
  print(roll);
  print(" \t");
  print(pitch);
  print(" \t");
  print(yaw);
  println();
  
  readServoRequest();
  if(need_serial) send_data();
  
}

void readIMU()
{
  int newLine = 13; // new line character in ASCII
  String message;
  do {
    message = IMUSensorPort.readStringUntil(newLine); // read from port until new line
    if (message != null) {
      String[] list = split(trim(message), " ");
      if (list.length >= 4 && list[0].equals("Orientation:")) {
        yaw = float(list[1]); // convert to float yaw
        pitch = float(list[2]); // convert to float pitch
        roll = float(list[3]); // convert to float roll

      }
    }
  } while (message != null);  
}

void readServoRequest(){
         need_serial = true;  
}

void drawCamera()
{
  /* function contains shape(s) that are rotated with the IMU */
  translate(0, 0, -100);
  stroke(0, 90, 90); // set outline colour to darker teal
  fill(0, 130, 130); // set fill colour to lighter teal
  box(200, 200, 10); // draw camera PCB base board

  stroke(0); // set outline colour to black
  fill(80); // set fill colour to dark grey
  translate(0, 0, -30); // draw camera lens
  box(50, 50, 50);

}

void drawGlasses()
{
  /* function contains shape(s) that are rotated with the IMU */
  translate(0, 0, -250);//draw black front panel
  stroke(0);
  fill(90);
  box(302, 142, 50);
  stroke(20);
  fill(200);
  translate(0, 0, 50);//draw white plastic volumn
  box(300, 140, 60);
  stroke(0);
  fill(90);
  translate(0, 0, 40);//draw black spur
  box(302, 142, 20);
  translate(150, 0, 120);//draw left belt
  box(10, 80, 250);
  translate(-300, 0, 0);//draw right belt
  box(10, 80, 250); 
  translate(150, -70, 0);//draw head belt
  box(80, 10, 250);
}
 void send_data()
 {
   pos = int(roll)%180;
   pos1 = int(yaw)%180;
  
   print("pos=");
   print(pos);
   print(',');
   print("pos1=");
   println(pos1);
   print(';');
   ServoPort.write('%');
   ServoPort.write(pos);
   ServoPort.write(pos1);
   need_serial = false;
 }