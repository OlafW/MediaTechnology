/*
   Sound, Space & Interaction
   Media Technology april 2020
   Olaf Wisselink
   'TouwSnaarVeer'

   This Arduino sketch requires the following MPU library:
   https://github.com/rpicopter/ArduinoMotionSensorExample
   For this project I used an MPU6500.

   This program calculates the amplitude of the gyroscope (sqrt(a^2 + b^2 + c^2))
   and sends this value as two digits over to Pure Data.
*/

#include <inv_mpu.h>
#include <inv_mpu_dmp_motion_driver.h>
#include <mpu.h>

int mpu_status; // return value of mpu
boolean plotSerial = false;

void setup() {
  Fastwire::setup(400, 0);
  Serial.begin(115200);

  mpu_status = mympu_open(200);
}

unsigned int c = 0; //cumulative number of successful MPU/DMP reads
unsigned int np = 0; //cumulative number of MPU/DMP reads that brought no packet back
unsigned int err_c = 0; //cumulative number of MPU/DMP reads that brought corrupted packet
unsigned int err_o = 0; //cumulative number of MPU/DMP reads that had overflow bit set

void loop() {
  mpu_status = mympu_update();

  switch (mpu_status) {
    case 0: c++; break;
    case 1: np++; return;
    case 2: err_o++; return;
    case 3: err_c++; return;
    default:
      Serial.print("READ ERROR!  ");
      Serial.println(mpu_status);
      return;
  }

  // Get amplitude of gyroscope
  float gyroVal = sqrt(mympu.gyro[0] * mympu.gyro[0] +
                       mympu.gyro[1] * mympu.gyro[1] +
                       mympu.gyro[2] * mympu.gyro[2]) / 3.0;

  if (plotSerial) {
    Serial.println(gyroVal);
    // Accelerometer
    //    Serial.print(" Y: "); Serial.print(mympu.ypr[0]);
    //    Serial.print(" P: "); Serial.print(mympu.ypr[1]);
    //    Serial.print(" R: "); Serial.print(mympu.ypr[2]);
    //    Serial.println();

    // Gyroscope
    //    Serial.print("\tgy: "); Serial.print(mympu.gyro[0]);
    //    Serial.print(" gp: "); Serial.print(mympu.gyro[1]);
    //    Serial.print(" gr: "); Serial.print(mympu.gyro[2]);
    //    Serial.println();
  }

  // Send data to PD
  else { 
    float scalar = 50.0;
    float maxGyro = 250.0 * scalar;

    gyroVal *= scalar;
    gyroVal = constrain_float(gyroVal, -maxGyro, maxGyro);
    gyroVal = (0.5 * gyroVal) + (0.5 * maxGyro);

    int lowerTwoDigits = (int)gyroVal % 100;
    int higherTwoDigits = gyroVal / 100;

    Serial.write(255);  // start byte
    Serial.write(lowerTwoDigits);
    Serial.write(higherTwoDigits);
  }
}

float constrain_float(float x, float minf, float maxf) {
  if (x < minf) return minf;
  else if (x > maxf) return maxf;
  else return x;
}
