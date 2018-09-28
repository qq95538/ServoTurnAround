/* 
 * rosserial Subscriber Example
 * Blinks an LED on callback
 */

#include <ros.h>
#include <std_msgs/Float64.h>
#include <Servo.h>


ros::NodeHandle  nh;
Servo myservo;  // create servo object to control a servo


void messageCb( const std_msgs::Float64& msg){
  int pos = 0;    // variable to store the servo position
  pos = constrain(msg.data, 0, 180);
  digitalWrite(13, HIGH-digitalRead(13));   // blink the led
  myservo.write(pos);

}

ros::Subscriber<std_msgs::Float64> sub("toggle_led", &messageCb );

void setup()
{ 
  pinMode(13, OUTPUT);
  nh.initNode();
  nh.subscribe(sub);

  myservo.attach(A6);  // attaches the servo on pin 9 to the servo object
}

void loop()
{  
  nh.spinOnce();
  delay(1);
}

