//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the timers used for lab4
//9/28/25

#include "STM32L432KC_TIM.h"

#define freqclk  4000000UL

void PWM(TIM *tim, uint32_t freq){
tim->SR &= ~1;  //update interupt flag
tim->ARR = (freqclk/freq)-1; // set the frequency
tim-> CCR1 = (uint32_t )(0.5*(tim->ARR+1)); // set duty cycle
tim->CCMR1 &= ~(0b111 << 4);//clear OC1M bits
tim->CCMR1 |=  (0b110 << 4);//set PWM mode 1
tim -> CCMR1  |= (1 << 3); // Coresponding PE on
tim->CR1 |= (1 << 7);// auto reload
tim->EGR |= 1;// init all regs
tim-> CCER |= 1;// enables output 
tim->CR1 |= 1; // start counter
}


void delay(TIM *tim, uint32_t ms) {
uint32_t presc = (uint32_t)((freqclk/1e3)-1); //initialize inter psc
tim ->PSC = presc-1; 
tim->EGR |= 1; // init presc
tim->SR &= ~1;  //update interupt flag
tim->ARR = ms; 
tim->CNT = 0;  //counter from 0
tim->CR1 |= 1; //start counter
while (!(tim->SR & 1)) {}
tim->CR1 &= ~1; //stop counter
}