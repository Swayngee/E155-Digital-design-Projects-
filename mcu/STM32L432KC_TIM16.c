//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the timers used for lab4
//9/28/25

#include "STM32L432KC_TIM16.h"

#define freqclk  4000000UL

void PWM(TIM *tim, uint32_t freq){
tim->SR &= ~1;  //update interupt flag
tim->ARR = (freqclk/freq)-1; // set the frequency
tim-> CCR1 = (uint32_t )(0.5*(tim->ARR+1)); // set duty cycle
tim->CCMR1 &= ~(0b111 << 4);//clear OC1M bits
tim->CCMR1 |=  (0b110 << 4);//set PWM mode 1
tim -> CCMR1  |= (1 << 3); // Coresponding PE on
tim->BDTR |= (1 << 15);
tim->CR1 |= (1 << 7);// auto reload
tim->EGR |= 1;// init all regs
tim-> CCER |= 1;// enables output 
tim->CR1 |= 1; // start counter
}
