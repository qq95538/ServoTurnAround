/**
 *processing control a 2-4 servos platform 
 *modified by qq95538 
 *
 *my email address is 190808149@qq.com
 *
 *The program serve for Visulizer.pde and FindFace.pde.
 */

/**
 *processing control a 4-DOF mechanical arm
 *by jorneryChen 
 *
 *my emial address is 1274104408@qq.com
 */
 int flowX;
 int flowY;

 boolean a = false;

 void setup() 
 {
   pinMode(13, OUTPUT);
   Serial.begin(9600);
   delay(8);
 }
 void loop() 
 {
   while(Serial.available()>2)
   {
     char data=Serial.read();
     if(data=='%')
     {
       flowX=Serial.read();
       flowY=Serial.read();
       a = !a;
       digitalWrite(13, a);   // turn the LED on (HIGH is the voltage level)
     }
   }
   //myservo.write(pos);
   //myservo1.write(pos1);
   delay(8);
   Serial.print("#");
 }
