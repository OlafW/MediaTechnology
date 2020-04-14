#include <inv_mpu.h>
#include <inv_mpu_dmp_motion_driver.h>
#include <mpu.h>

int mpu_status; // return value of mpu

int serialInterval = -1;
unsigned long prevTime = 0;

void setup() {
  Fastwire::setup(400, 0);
  Serial.begin(38400);
  
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

  if (!(c % 25)) {
    // Accelerometer
//    Serial.print(" Y: "); Serial.print(mympu.ypr[0]);
//    Serial.print(" P: "); Serial.print(mympu.ypr[1]);
//    Serial.print(" R: "); Serial.print(mympu.ypr[2]);

    // Gyroscope
//    Serial.print("\tgy: "); Serial.print(mympu.gyro[0]);
//    Serial.print(" gp: "); Serial.print(mympu.gyro[1]);
//    Serial.print(" gr: "); Serial.print(mympu.gyro[2]);
//    Serial.println();

    // Send data to PD
    // start byte
    Serial.write(255);
    
    // x,y,z data
    float scalar = 10.0; // 50
    float maxGyro = 250.0 * scalar;

    for (int i = 0; i < 3; i++) {
      float val = mympu.gyro[i] * scalar;

      val = constrain_float(val, -maxGyro, maxGyro);
      val = (0.5*val) + (0.5*maxGyro);
      
      int lowerTwoDigits = (int)val % 100;
      int higherTwoDigits = val / 100;
      
      Serial.write(lowerTwoDigits);
      Serial.write(higherTwoDigits);
    }
  }
}

float constrain_float(float x, float minf, float maxf) {
  if (x < minf) return minf;
  else if (x > maxf) return maxf;
  else return x;
}
