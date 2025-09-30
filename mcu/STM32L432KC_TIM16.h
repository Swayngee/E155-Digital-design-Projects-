// Drake Gonzales
// drgonzales@g.hmc.edu
// This Moduleis my header file for the timers used for lab4
// 9/28/25

#ifndef STM32L4_TIM16_H
#define STM32L4_TIM16_H

#include <stdint.h>

// DEF TIM15, TIM16, TIM7 

#define TIM16_BASE (0x40014400UL)

#define TIM15_BASE (0x40014000UL)

// Strct registers for timers, I wrote them all out for future reference
typedef struct {
    volatile uint32_t CR1;   // timer Offset 0x00 
    volatile uint32_t CR2;  // timer Offset 0x04
    volatile uint32_t SMCR; // timer Offset 0x08
    volatile uint32_t DIER;  // timer Offset 0x0C
    volatile uint32_t SR;    // timer Offset 0x10
    volatile uint32_t EGR;    // timer Offset 0x14
    volatile uint32_t CCMR1;  // timer Offset 0x18
    uint32_t      RESERVED1; // Reserved,                                                        
    volatile uint32_t CCER;  // timer Offset 0x20
    volatile uint32_t CNT;   // timer Offset 0x24
    volatile uint32_t PSC;   // timer Offset 0x28
    volatile uint32_t ARR;   // timer Offset 0x2C
    volatile uint32_t RCR;   // timer Offset 0x30
    volatile uint32_t CCR1;  // timer Offset 0x34
    volatile uint32_t CCR2;  // timer Offset 0x38
    uint32_t      RESERVED2; //Reserved                                                                
    uint32_t      RESERVED3; //Reserved   
    volatile uint32_t BDTR;  // timer Offset 0x44
    volatile uint32_t DCR;   // timer Offset 0x48
    volatile uint32_t DMAR;  // timer Offset 0x4C
    volatile uint32_t OR1;   // timer Offset 0x50
    uint32_t      RESERVED4; //Reserved  
    uint32_t      RESERVED5; //Reserved  
    uint32_t      RESERVED6;   //Reserved  
    uint32_t      RESERVED7;   //Reserved  
    volatile uint32_t OR2;   // timer Offset 0x60
} TIM;

// Pointers to TIM-sized chunks of memory for each peripheral
#define TIM15 ((TIM *) TIM15_BASE)
#define TIM16 ((TIM *) TIM16_BASE)

void config16(void);
void PWM(int freq);

#endif