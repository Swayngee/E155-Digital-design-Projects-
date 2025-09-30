// Drake Gonzales
// drgonzales@g.hmc.edu
// This Moduleis my header file for the timers used for lab4
// 9/28/25

#ifndef STM32L4_TIM6_H
#define STM32L4_TIM6_H

#include <stdint.h>

// DEF TIM6

#define TIM6_BASE (0x40001000UL)

// Strct registers for timers, I wrote them all out for future reference
typedef struct {
    volatile uint32_t CR1;   // timer Offset 0x00 
    volatile uint32_t CR2;  // timer Offset 0x04
    uint32_t      RESERVED1; //Reserved      
    volatile uint32_t DIER;  // timer Offset 0x0C
    volatile uint32_t SR;    // timer Offset 0x10
    volatile uint32_t EGR;    // timer Offset 0x14
    uint32_t      RESERVED2; //Reserved   
    uint32_t      RESERVED3; //Reserved   
    uint32_t      RESERVED4; //Reserved     
    volatile uint32_t CNT;   // timer Offset 0x24
    volatile uint32_t PSC;   // timer Offset 0x28
    volatile uint32_t ARR;   // timer Offset 0x2C
} Tim6;

// Pointers to TIM-sized chunks of memory for each peripheral
#define TIM6 ((Tim6 *) TIM6_BASE)

void configtim6(void);
void delay(uint32_t ms);

#endif