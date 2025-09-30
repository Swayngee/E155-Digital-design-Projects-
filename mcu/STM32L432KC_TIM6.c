//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the timers used for lab4
//9/28/25

#include "STM32L432KC_TIM6.h"
#include "STM32L432KC_RCC.h"

#define freqclk  4000000UL

void configtim6(void){
RCC->APB1ENR1 |= (1 << 4); 
TIM6 -> PSC = 3999; //set presc
TIM6 -> CR1 |= (1 << 7); // autoreload 
TIM6 -> EGR |= (1 << 0); // init pres
}

void delay(uint32_t ms) {
TIM6->ARR = ms -1;
TIM6->EGR |= 1; // init presc
TIM6->SR &= ~1;  //update interupt flag 
TIM6->CNT = 0;  //counter from 0
TIM6->CR1 |= 1; //start counter
while (!(TIM6->SR & 1)) {}
TIM6->SR &= ~1; //UIF
TIM6->CR1 &= ~1;
}