#include "Wire.h"

#define PCF8591 (0x90 >> 1) // I2C bus address

#define ADC0  0x00
#define ADC1  0x01
#define ADC2  0x02
#define ADC3  0x03
#define DAC0  0x40

byte gValue0, gValue1, gValue2, gValue3;

const uint8_t  MA_WINDOW_SIZE = 32; // Moving-average length (e.g., 4, 8, 16, 32)
uint8_t gRingBuffer[64];  // Max supported window = 64 (adjust if needed)  
uint8_t gRingBufferPos = 0;
uint16_t gRunningSum = 0;

// Moving-Average (MA) FIR
inline uint8_t MA_Filter(uint8_t x) {
  // Remove oldest, add newest
  gRunningSum -= gRingBuffer[gRingBufferPos];
  gRingBuffer[gRingBufferPos] = x;
  gRunningSum += x;

  gRingBufferPos++;  // increment position
  if (gRingBufferPos >= MA_WINDOW_SIZE) gRingBufferPos = 0;  // compare-reset faster than %
  //gRingBufferPos = gRingBufferPos % MA_WINDOW_SIZE;  // % involves division - last option

  // Divide by N (N fits in uint8_t; sum fits in uint16_t for N<=64)
  uint8_t y = (uint8_t)(gRunningSum / MA_WINDOW_SIZE);  // divide by 4 = to multiply by 0.25
  //uint8_t y = gRunningSum >> 2;  // divide by 4 -> shifts are faster but work only with powers of 2

  return y;
}

void setup()
{
  // I2C Config
  Wire.begin();
  Wire.setClock(100000);      // 100 kHz (Standard-mode, default)

  // Serial Config
  Serial.begin(115200);

  // Initialize ring buffer
  for (uint8_t i = 0; i < MA_WINDOW_SIZE; i++) {
    gRingBuffer[i] = 0;
  }
  gRunningSum = 0;
  gRingBufferPos = 0;
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
  gValue0 = Wire.read();  // actual conversion
  // *****************************

  // FILTER
  // *****************************
  uint8_t y = MA_Filter(gValue0);
  // *****************************

  // DAC
  // *****************************
  Wire.beginTransmission(PCF8591); // wake up PCF8591
  Wire.write(DAC0); // control byte - turn on DAC (binary 01000000),analog OUTPUT
  Wire.write(y); // value to send to DAC
  Wire.endTransmission(); // end tranmission
  // *****************************

  // Sampling Rate
  delay(1);

  // Plot data on the computer
  Serial.print(gValue0);
  Serial.print(",");
  Serial.println(y);
}