// Drake Gonzales
// drgonzales@g.hmc.edu
// This Moduleis my header file for the timers used for lab4
// 9/28/25


#include "STM32L432KC.h"
#include "DS1722.h"

/* Configures the temperature sensor by writing to specific registers
* config-- Configuration defined by the Users input to the Webpage
* lsb-- Retreive the decimal value of the temp value output from the sensor  
* msb-- Retreive the signed value and whole number value stemming from the sensors registers
* returns a call to the decoder function
*/
float updateTemp(int32_t config) {
    uint8_t lsb = 0;
    uint8_t msb = 0;

    //Write to Config read address
    digitalWrite(PA11, 1); 
    spiSendReceive(WRITE_CONFIG);  
    spiSendReceive(config); 
    digitalWrite(PA11, 0);

    // Read temperature lsb read address
    digitalWrite(PA11, 1);
    spiSendReceive(READ_TEMPLSB); 
    lsb = spiSendReceive(0x00);
    digitalWrite(PA11, 0);

    // Read temperature msb read address
    digitalWrite(PA11, 1);
    spiSendReceive(READ_TEMPMSB);
    msb = spiSendReceive(0x00); 
    digitalWrite(PA11, 0);

    return decodeTemp(lsb,msb);
}

/* Decodes the temperature value comming from the sensors registers
* wholeNumberTemp-- stems from msb 
* decimalTemp-- stems from lsb
* returns decimal + whole number value
*/
float decodeTemp(uint8_t lsb, uint8_t msb) {
  int8_t wholeNumberTemp = 0;

  // Check if signed
  if(msb>> 7 == 1){ 
    wholeNumberTemp = -128 + (msb & 0x7F);
  } else {
    wholeNumberTemp = (msb & 0x7F);
  }
  double decimalTemp = 0.0;

  // Read individual lsb bits
  // Output decimal value corresponding to binary input
  if (lsb & 0x80) {
    decimalTemp += 0.5;
  }
  if (lsb & 0x40) {
    decimalTemp += 0.25;
  }
  if (lsb & 0x20) {
    decimalTemp += 0.125;
  }
  if (lsb & 0x10) {
    decimalTemp += 0.0625;
  }
  return decimalTemp + (double)wholeNumberTemp;
}