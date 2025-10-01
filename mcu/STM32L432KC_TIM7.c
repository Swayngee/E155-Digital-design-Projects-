//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the timers used for lab4
//9/28/25

#include "STM32L432KC_TIM7.h"
#include "STM32L432KC_RCC.h"

void configtim7(void){
RCC->APB1ENR1 |= (1 << 5); //enable tim7
TIM7 -> PSC = 39; //set presc -> 100,000 Hz clk

TIM7 -> CR1 |= (1 << 7); // autoreload 
TIM7 -> EGR |= (1 << 0); // init pres
}

void delay(uint32_t ms) {
TIM7->ARR = (100*ms-1); // 10 microseconds per count * 100  = 1ms
TIM7->EGR |= 1; // init presc
TIM7->SR &= ~1;  //update interupt flag 

TIM7->CNT = 0;  //counter from 0
TIM7->CR1 |= 1; //start counter
while (!(TIM7->SR & 1)) {} 
TIM7->SR &= ~1; //UIF
}
