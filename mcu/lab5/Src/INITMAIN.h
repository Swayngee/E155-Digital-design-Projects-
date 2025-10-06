#ifndef INITMAIN_H
#define INITMAIN_H

#include <stm32l432xx.h>

#define pinB PA2
#define pinA PA1

#define DELAY_TIM TIM2

extern volatile int countA;
extern volatile int countB;

void inintAB(void);
void EXTI2_IRQHandler(void);
void EXTI1_IRQHandler(void);
void GPIOenable(void);
void timenable(void);
int _write(int file, char *ptr, int len);

#endif