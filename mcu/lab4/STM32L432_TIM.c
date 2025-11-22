// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module is my c file for the timers used for lab4
// 9/23/25



#include "STM32L432KC_TIM.h"
#include "STM32L432KC_GPIO.h"


#define freq 4000000

void initTIM15(TIM15){
uint32_t psc_div = (uint32_t) ((freq/1e3)-1);

TIM15->PSC(psc_div-1);
TIM15->EGR |=1;
TIM15->CR1 |= 1;
}

void initTIM16(TIM16){



}




void delay_millis(TIM_TypeDef * TIMx, uint32_t ms){




}