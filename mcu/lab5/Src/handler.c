//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the interupt handlers
//1/4/25

#include <stm32l432xx.h>
#include "STM32L432KC.h"
#include "main.h"


volatile int32_t position = 0;
//below is the code for setting the counter
//position is the counter value based on each interrupt
void EXTI1_IRQHandler(void){
  if(EXTI->PR1 &(1<<1)){ // triggers the interrupt. If this condition is true, the following code runs
      EXTI -> PR1 |=(1<<1); // if so, clear the interrupt (NB: Write 1 to reset.)

        int A = (GPIOA->IDR & (1 << gpioPinOffset(pinA))) != 0; // int A is the encoder A signal from the motor
        int B = (GPIOA->IDR & (1 << gpioPinOffset(pinB))) != 0; // int B is the encoder B signal from the motor

        if (A == B){ //A is on when b is on
        position = position -1 ; // side effect from interrupt
        }

        else{
        position = position + 1 ; // side effect from interrupt
        }

    }
}

void EXTI2_IRQHandler(void){
    if (EXTI->PR1 & (1 << 2)){ // this code directly triggers the interrupt. If this condition is true, the following code runs
        EXTI->PR1 |= (1 << 2); // if so, clear the interrupt (NB: Write 1 to reset.)

        int A = (GPIOA->IDR & (1 << gpioPinOffset(pinA))) != 0; // int A is the encoder A signal from the motor
        int B = (GPIOA->IDR & (1 << gpioPinOffset(pinB))) != 0; // int B is the encoder B signal from the motor

        if (A != B){  // they are both off on A's fall
        position = position - 1; // side effect from interrupt
        }
        else{
        position = position + 1; // Side effect from interrupt
        } 

    }
}


