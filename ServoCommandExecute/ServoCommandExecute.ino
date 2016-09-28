/**
 *processing control a 2-4 servos platform 
 *modified by qq95538 
 *
 *my email address is 190808149@qq.com
 */

/**
 *processing control a 4-DOF mechanical arm
 *by jorneryChen 
 *
 *my emial address is 1274104408@qq.com
 */
 #include<Servo.h>

 Servo myservo;
 Servo myservo1;
 Servo myservo2;
 Servo myservo3;

 int servo =A6;//define servo control pin number on a megaPI board
 int servo1=A7;
 int servo2=A8;
 int servo3=A9;

 int pos;
 int pos1;
 int pos2;
 int pos3;

 void setup() 
 {
   Serial.begin(9600);
   myservo.attach(servo);
   myservo1.attach(servo1);
   myservo2.attach(servo2);
   myservo3.attach(servo3);
   pos=90;
   pos1=90;
   pos2=90;
   pos3=90;
   updateServo();
 }
 void loop() 
 {
   recv_data();
   updateServo();
 } 
 void recv_data()
 {
   while(Serial.available()>=8)
   {
     char data=Serial.read();
     if(data=='%')
     {
       pos=Serial.read();
       pos1=Serial.read();
       pos2=Serial.read();
       pos3=Serial.read();
     }
   }
 }

 void updateServo()
 {
   myservo.write(pos);
   myservo1.write(pos1);
   myservo2.write(pos2);
   myservo3.write(pos3);
   delay(8);
 }
