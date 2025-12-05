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
    
    spiSendReceive(0xAA);
    spiSendReceive(0x55);
    
    // Then send ADC values
    for(int i = 0; i < 3; i++) {
        spiSendReceive(values[i] >> 8);
        spiSendReceive(values[i] & 0xFF);
    }
    
    digitalWrite(PA11, 1);  // CS high
    for(volatile int i = 0; i < 100000; i++);  
}
}

