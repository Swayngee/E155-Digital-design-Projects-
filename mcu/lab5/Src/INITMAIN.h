//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my h file for main. it combines my init and handler c files
//1/4/25


#ifndef INITMAIN_H
#define INITMAIN_H

#include <stm32l432xx.h>

#define pinB PA2
#define pinA PA1

#define DELAY_TIM TIM2

extern volatile int32_t position;

void inintAB(void);
void EXTI2_IRQHandler(void);
void EXTI1_IRQHandler(void);
void GPIOenable(void);
void timenable(void);
int _write(int file, char *ptr, int len);

#endif
