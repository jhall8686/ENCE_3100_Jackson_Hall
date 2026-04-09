#include "Wire.h"

#define PCF8591 (0x90 >> 1) // I2C bus address

#define ADC0  0x00
#define ADC1  0x01
#define ADC2  0x02
#define ADC3  0x03
#define DAC0  0x40



byte value0, value1, value2, value3;

uint8_t x_n1;
#define a0 0.5
#define a1 0.5

//Simple FIR Filter

inline uint8_t FIR_Filter(uint8_t x_n) 
{
  //Get input
  //(Function arg)

  //Compute Filter

  uint8_t y_n = a0*x_n + a1*x_n1;

  //Update States
  x_n1 = x_n;

  //Output filtered value

  return y_n;
}

void setup()

{
  // I2C Config
  Wire.begin();
  Wire.setClock(100000);      // 100 kHz (Standard-mode, default)

  // Serial Config
  Serial.begin(115200);

  //Initialize States
  x_n1 = 0;
}
void loop()
{
  // ADC
  // *****************************
  Wire.beginTransmission(PCF8591); // wake up PCF8591
  Wire.write(DAC0 | ADC1); // control byte - read ADC0 and keep DAC on
  Wire.endTransmission(); // end tranmission

  Wire.requestFrom(PCF8591, 2);
  (void)Wire.read();  // dummy value
  value0 = Wire.read();  // actual conversion


  // *****************************

  // FILTER
  uint8_t y = FIR_Filter(value0);


  // DAC
  // *****************************
  Wire.beginTransmission(PCF8591); // wake up PCF8591
  Wire.write(DAC0); // control byte - turn on DAC (binary 01000000),analog OUTPUT
  Wire.write(y); // value to send to DAC
  Wire.endTransmission(); // end tranmission
  // *****************************

  // Sampling Rate

  // Plot data on the computer
  Serial.print(value0);
  Serial.print(",");
  Serial.println(y);
}