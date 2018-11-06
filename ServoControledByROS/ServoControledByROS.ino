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
Servo joint1, joint2;  // create servo object to control a servo

void messageCb(const sensor_msgs::JointState& msg){
  int angle1, angle2;
  angle1 = constrain(msg.position[0]/3.141592654/2*360, 0, 180);
  angle2 = constrain(msg.position[1]/3.141592654/2*360, 0, 180);
  digitalWrite(13, HIGH-digitalRead(13));   // blink the led
  joint1.write(angle1);
  joint2.write(angle2);

}

ros::Subscriber<sensor_msgs::JointState> sub("joint_states", &messageCb );

void setup()
{ 
  pinMode(13, OUTPUT);
  nh.initNode();
  nh.subscribe(sub);

  joint1.attach(A6);  // attaches the servo on pin to the servo object
  joint2.attach(A7);
  joint1.write(0);
  joint2.write(0);
}

void loop()
{  
  nh.spinOnce();
  delay(1);
}

