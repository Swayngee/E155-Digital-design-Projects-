//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my init.c file for all of my functions used
//1/4/25
    

#include <stm32l432xx.h>
#include "INITMAIN.h"
#include "STM32L432KC.h"



void inintAB(void){
    // 1. Enable SYSCFG clock domain in RCC
    RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
    // 2. Configure EXTICR for the input button interrupt
    SYSCFG->EXTICR[0] |= _VAL2FLD(SYSCFG_EXTICR1_EXTI1, 0b000); // Select PA1
    SYSCFG->EXTICR[0] |= _VAL2FLD(SYSCFG_EXTICR1_EXTI2, 0b000); // Select PA2

    // Enable interrupts globally
    __enable_irq();

    // pin A = PA1
    // pin B = PA2
    // 1. Configure mask bit
    EXTI->IMR1 |= (1 << gpioPinOffset(pinA)); // Configure the mask bit
    EXTI->RTSR1 |= (1 << gpioPinOffset(pinA));// enable rising edge trigger
    EXTI->FTSR1 |= (1 << gpioPinOffset(pinA));// Enable falling edge trigger
    NVIC->ISER[0] |= (1 << EXTI1_IRQn);



    EXTI->IMR1 |= (1 << gpioPinOffset(pinB));  // Configure the mask bit
    EXTI->RTSR1 |= (1 << gpioPinOffset(pinB)); // enable rising edge trigger
    // 3. Enable falling edge trigger
    EXTI->FTSR1 |= (1 << gpioPinOffset(pinB)); // enable falling edge trigger
    // 4. Turn on EXTI interrupt in NVIC_ISER
    NVIC->ISER[0] |= (1 << EXTI2_IRQn); 

}

void GPIOenable(void){ 
gpioEnable(GPIO_PORT_A); //enable GPIO A
pinMode(PA1, GPIO_INPUT);  
GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD1, 0b10);  //pull down

gpioEnable(GPIO_PORT_A);
pinMode(PA2, GPIO_INPUT);
GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD2, 0b10); // pull down

}

void timenable(void){
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN; //enable TIM2
    initTIM(DELAY_TIM); //init timer
}


// Function used by printf to send characters to the laptop
int _write(int file, char *ptr, int len) {
  int i = 0;
  for (i = 0; i < len; i++) {
    ITM_SendChar((*ptr++));
  }
  return len;
}
