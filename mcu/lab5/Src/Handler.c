//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my c file for the interupt handlers
//1/4/25

#include <stm32l432xx.h>
#include "INITMAIN.h"


volatile int32_t countA = 0;
volatile int32_t countB = 0;
//below is the code for setting the counter
void EXTI1_IRQHandler(void){
  if(EXTI->PR1 &(1<<1)){
      // If so, clear the interrupt (NB: Write 1 to reset.)
      EXTI -> PR1 |=(1<<1);
        int A = (GPIOA->IDR & (1 << 1)) != 0;
        int B = (GPIOA->IDR & (1 << 2)) != 0;

        if (A == B){ //A is on when b is falling
        countA = countA + 1;
        }
        else{
        countA = countA - 1 ;
        }

    }
}

void EXTI2_IRQHandler(void){
    if (EXTI->PR1 & (1 << 2)){
        // If so, clear the interrupt (NB: Write 1 to reset.)
        EXTI->PR1 |= (1 << 2);

        int A = (GPIOA->IDR & (1 << 1)) != 0;
        int B = (GPIOA->IDR & (1 << 2)) != 0;
        if (A != B){ // they are both off on A's fall
        countB = countB + 1;
        }
        else{
        countB = countB - 1;
        }

    }
}




