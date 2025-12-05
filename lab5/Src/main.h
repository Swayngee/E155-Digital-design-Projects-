//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my h file for main. it combines my init and handler c files
//1/4/25


#ifndef main_H
#define main_H

#include <stm32l432xx.h>
//PA1 and PA2 are 5V acceptable pins. PA2 is p7 on the board 
#define pinB PA2
#define pinA PA1

#define DELAY_TIM TIM2
//make position a global var so that the main can use it. Searched this 'extern' func online
extern volatile int32_t position;
//init funcs
void inintAB(void);
void EXTI2_IRQHandler(void);
void EXTI1_IRQHandler(void);
void GPIOenable(void);
void timenable(void);
int _write(int file, char *ptr, int len);

#endif
