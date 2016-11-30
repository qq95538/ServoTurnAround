
/*
   ===============================================
   Example sketch for CurieIMU library for Intel(R) Curie(TM) devices.
   Copyright (c) 2015 Intel Corporation.  All rights reserved.

   Based on I2C device class (I2Cdev) demonstration Arduino sketch for MPU6050
   class by Jeff Rowberg: https://github.com/jrowberg/i2cdevlib

   ===============================================
   I2Cdev device library code is placed under the MIT license
   Copyright (c) 2011 Jeff Rowberg

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
   ===============================================

   Genuino 101 CurieIMU Orientation Visualiser
   Hardware Required:
   * Arduino/Genuino 101

   Modified Nov 2015
   by Helena Bisby <support@arduino.cc>
   This example code is in the public domain
   http://arduino.cc/en/Tutorial/Genuino101CurieIMUOrientationVisualiser
 */


#include <CurieIMU.h>
#include <MadgwickAHRS.h>

 Madgwick filter;
unsigned long microsPerReading, microsPrevious;
float accelScale, gyroScale;

void setup() {
   Serial.begin(9600);

   // start the IMU and filter
   CurieIMU.begin();
   CurieIMU.autoCalibrateGyroOffset();
   CurieIMU.autoCalibrateAccelerometerOffset(X_AXIS, 0);
   CurieIMU.autoCalibrateAccelerometerOffset(Y_AXIS, 1);
   CurieIMU.autoCalibrateAccelerometerOffset(Z_AXIS, 0);
   CurieIMU.setGyroRate(25);
   CurieIMU.setAccelerometerRate(25);
   filter.begin(25);

   // Set the accelerometer range to 2G
   CurieIMU.setAccelerometerRange(2);
   // Set the gyroscope range to 250 degrees/second
   CurieIMU.setGyroRange(250);

   // initialize variables to pace updates to correct rate
   microsPerReading = 1000000 / 25;
   microsPrevious = micros();
}

void loop() {
   int aix, aiy, aiz;
   int gix, giy, giz;
   float ax, ay, az;
   float gx, gy, gz;
   float roll, pitch, heading;
   unsigned long microsNow;

   // check if it's time to read data and update the filter
   microsNow = micros();
   if (microsNow - microsPrevious >= microsPerReading) {

     // read raw data from CurieIMU
     CurieIMU.readMotionSensor(aix, aiy, aiz, gix, giy, giz);

     // convert from raw data to gravity and degrees/second units
     //ax = convertRawAcceleration(aix);
     ax = convertRawAcceleration(aiz);
     //ay = convertRawAcceleration(aiy);
     ay = convertRawAcceleration(aix);
     //az = convertRawAcceleration(aiz);
     az = convertRawAcceleration(aiy);
     //gx = convertRawGyro(gix);
     gx = convertRawGyro(giz);
     //gy = convertRawGyro(giy);
     gy = convertRawGyro(gix);
     //gz = convertRawGyro(giz);
     gz = convertRawGyro(giy);  
       
     // update the filter, which computes orientation
     filter.updateIMU(gx, gy, gz, ax, ay, az);

     // print the heading, pitch and roll
     roll = filter.getRoll();
     pitch = filter.getPitch();
     heading = filter.getYaw();
     Serial.print("Orientation: ");
     Serial.print(heading);
     Serial.print(" ");
     Serial.print(pitch);
     Serial.print(" ");
     Serial.println(roll);

     // increment previous time, so we keep proper pace
     microsPrevious = microsPrevious + microsPerReading;
   }
}

float convertRawAcceleration(int aRaw) {
   // since we are using 2G range
   // -2g maps to a raw value of -32768
   // +2g maps to a raw value of 32767
   
   float a = (aRaw * 2.0) / 32768.0;
   return a;
}

float convertRawGyro(int gRaw) {
   // since we are using 250 degrees/seconds range
   // -250 maps to a raw value of -32768
   // +250 maps to a raw value of 32767
   
   float g = (gRaw * 250.0) / 32768.0;
   return g;
}



