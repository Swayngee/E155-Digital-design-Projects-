#include <stdio.h>
#include <stdint.h>
#include "STM32L432KC.h"

int main(void) {
    RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN |
                     RCC_AHB2ENR_ADCEN);
    initSPI(1, 0, 0);

    gpioEnable(GPIO_PORT_A);
    gpioEnable(GPIO_PORT_B);
    gpioEnable(GPIO_PORT_C);

    pinMode(PA11, GPIO_OUTPUT);
    digitalWrite(PA11, 1);  // CS idle HIGH
    configureADC();
while(1){
    readADC();
         
    digitalWrite(PA11, 0);  // CS low
    
    spiSendReceive(0xAA);  // Sync byte 1
    spiSendReceive(0x55);  // Sync byte 2
    
    // Send 5 ADC values (10 bytes total)
    for(int i = 0; i < 5; i++) {
        spiSendReceive(values[i] >> 8);    // MSB of ADC value
        spiSendReceive(values[i] & 0xFF);  // LSB of ADC value
    }
    
    // Send Low-pass filter coefficients (10 bytes)
    spiSendReceive(0x40); spiSendReceive(0x00);  // LOW_B0 = 0x4000
    spiSendReceive(0x00); spiSendReceive(0x00);  // LOW_B1 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // LOW_B2 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // LOW_A1 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // LOW_A2 = 0x0000
    
    // Send Mid-pass filter coefficients (10 bytes)
    spiSendReceive(0x40); spiSendReceive(0x00);  // MID_B0 = 0x4000
    spiSendReceive(0x00); spiSendReceive(0x00);  // MID_B1 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // MID_B2 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // MID_A1 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // MID_A2 = 0x0000
    
    // Send High-pass filter coefficients (10 bytes)
    spiSendReceive(0x40); spiSendReceive(0x00);  // HIGH_B0 = 0x4000
    spiSendReceive(0x00); spiSendReceive(0x00);  // HIGH_B1 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // HIGH_B2 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // HIGH_A1 = 0x0000
    spiSendReceive(0x00); spiSendReceive(0x00);  // HIGH_A2 = 0x0000
    
    digitalWrite(PA11, 1);  // CS high
    for(volatile int i = 0; i < 100000; i++);  
}
}

