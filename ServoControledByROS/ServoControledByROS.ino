/* 
 * rosserial Subscriber Example
 * turn a Servo on callback
 * Burn the following sketch to a Arduino 2560 board with a servo connected on Pin6.  
 * Enter a command of "rosrun rosserial_python serial_node.py /dev/ttyUSB__" to create a rosserial node communicating with the Arduino board.  
 * The node subsrcibes Topic 'JointStates' and the arduino board, turns the servo on Pin6 to the joint angle of the topic. 
 */

#include <ros.h>
#include <sensor_msgs/JointState.h>
#include <std_msgs/Float64.h>
#include <Servo.h>


ros::NodeHandle  nh;
Servo myservo;  // create servo object to control a servo
sensor_msgs::JointState pos;

void messageCb(const sensor_msgs::JointState& msg){
  int angle;
  pos = msg;
  angle = constrain(pos.position[0]/3.1416*360, 0, 180);
  digitalWrite(13, HIGH-digitalRead(13));   // blink the led
  myservo.write(angle);

}

ros::Subscriber<sensor_msgs::JointState> sub("joint_states", &messageCb );

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

