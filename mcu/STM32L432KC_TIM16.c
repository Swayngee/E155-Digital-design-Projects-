//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the timers used for lab4
//9/28/25

#include "STM32L432KC_TIM16.h"
#include "STM32L432KC_RCC.h"

#define freqclk 1000000

void config16(void) {
//enable clocks presc and counter up value
RCC -> AHB2ENR |= 1;
RCC -> APB2ENR |= (1 << 17);
TIM16 -> PSC = 3;
TIM16 -> ARR = 0xFFFF;

TIM16 ->CCMR1 &= ~(0b111 << 4); //clear OC1M bits
TIM16 ->CCMR1 |=  (0b110 << 4);//set PWM mode 1
TIM16 -> CCMR1  |= (1 << 3); // Coresponding PE on
TIM16 -> CCMR1 &= ~(0b11 <<0);
TIM16->CR1 |= (1 << 7);// auto reload
TIM16 -> CCER |= 1;// enables output 
TIM16->BDTR |= (1 << 15); // MOE
TIM16 -> CCR1 = 0; 
TIM16->EGR |= 1;// init all regs
TIM16 ->CR1 |= 1; // start counter
}


void PWM(int freq){
TIM16 ->ARR = (1000000 / freq) -1; // set the frequency
TIM16-> CCR1 = ((TIM16->ARR +1 ) /2  ); // set duty cycle
TIM16 -> EGR |= 1; //init reg
}