#include "Wire.h"

#define PCF8591 (0x90 >> 1) // I2C bus address

#define ADC0  0x00
#define ADC1  0x01
#define ADC2  0x02
#define ADC3  0x03
#define DAC0  0x40

byte gValue0, gValue1, gValue2, gValue3;

// --- One-pole IIR state ---
// y[n] = y[n−1] + α(x[n] − y[n−1])
static float y_state = 0.0f;

// User settings
const float Fs_target = 1000.0f;   // ~1 kHz (matches delay below)
const float FC_MIN    = 1.0f;      // Hz (floor cutoff)
const float FC_MAX    = 200.0f;    // Hz (ceiling cutoff)

// Map pot [0..255] to cutoff in Hz (log sweep for nicer feel)
static inline float potToFc(byte pot)
{
  float t = pot / 255.0f;
  // Logarithmic mapping:
  float ratio = FC_MAX / FC_MIN;         // e.g., 200x
  return FC_MIN * powf(ratio, t);        // FC_MIN .. FC_MAX
  // If you want linear instead: return FC_MIN + t*(FC_MAX-FC_MIN);
}

// 1st order LPF (compute alpha from fc each sample)
static inline uint8_t IIR_LPF_1order(uint8_t x_u8, float fc, float Fs) 
{
  // convert to float
  float x = (float)x_u8;

  // compute alpha = 1 - exp(-2*pi*fc/Fs)
  float alpha = 1.0f - expf(-2.0f * PI * fc / Fs);

  // update filter state
  y_state += alpha * (x - y_state);

  // clamp back to 0..255 and return
  if (y_state < 0.0f)   y_state = 0.0f;
  if (y_state > 255.0f) y_state = 255.0f;
  return (uint8_t)(y_state + 0.5f);
}

void setup()
{
  // I2C Config
  Wire.begin();
  Wire.setClock(100000);      // 100 kHz (Standard-mode, default)

  // Serial Config
  Serial.begin(115200);

  // Initialize IIR
  y_state = 0.0f;
}

void loop()
{
  // ADC
  // *****************************

  // ---- Read ADC0 (pot) ----
  Wire.beginTransmission(PCF8591); // wake up PCF8591
  Wire.write(DAC0 | ADC0); // control byte - read ADC0 and keep DAC on
  Wire.endTransmission(); // end tranmission

  Wire.requestFrom(PCF8591, 2);
  (void)Wire.read();  // dummy value
  gValue1 = Wire.read();  // actual conversion

  // ---- Read ADC1 (pot) ----
  Wire.beginTransmission(PCF8591);
  Wire.write(DAC0 | ADC1);
  Wire.endTransmission();
  Wire.requestFrom(PCF8591, 2);
  (void)Wire.read();                 // dummy
  gValue0 = Wire.read();             // pot value 0..255

  // *****************************

  // FILTER
  // *****************************
  // Map pot to cutoff and filter
  float fc = potToFc(gValue1);
  uint8_t y = IIR_LPF_1order(gValue0, fc, Fs_target);
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
  Serial.print(',');
  Serial.print((int)gValue1);
  Serial.print(',');
  Serial.println((int)y);
}