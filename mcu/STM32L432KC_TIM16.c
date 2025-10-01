//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the timers used for lab4
//9/28/25

#include "STM32L432KC_TIM16.h"
#include "STM32L432KC_RCC.h"

#define freqclk 4000000 // msi input freq to PLL

void config16(void) {
// the following code below is init the timer to PWM mode 1
//enable clocks presc and counter up value
RCC -> AHB2ENR |= 1; //enable GPIOA
RCC -> APB2ENR |= (1 << 17); // TIM16 en
TIM16 -> PSC = 3; // freq = 1MHZ, keep it simple. Verify math later

TIM16 ->CCMR1 &= ~(0b111 << 4); //clear OC1M bits
TIM16 ->CCMR1 |=  (0b110 << 4);//set PWM mode 1
TIM16 -> CCMR1  |= (1 << 3); // Coresponding PE on
TIM16 -> CCMR1 &= ~(0b11 <<0); // CC1 channel is configured as input.IC1 is mapped on TRC
TIM16->CR1 |= (1 << 7);// auto reload

TIM16 -> CCER |= 1;// enables output 
TIM16->BDTR |= (1 << 15); // MOE

TIM16 -> CCR1 = 0; // PWM starts low

TIM16->EGR |= 1;// init all regs
TIM16 ->CR1 |= 1; // start counter
}

void PWM(int freq){
if (freq == 0) return;
else{
TIM16 ->ARR = (freqclk / ((TIM16 -> PSC +1) * freq)) - 1; // set the frequency to count up to 
TIM16-> CCR1 = ((TIM16->ARR +1 ) /2  ); // set duty cycle -> (multiply by 1/2) 
TIM16 -> EGR |= 1; //init reg
}
}
