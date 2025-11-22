// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module is a DS1722 Tempertaure sensor configuration header file
// 10/21/25

#ifndef DS1722_H
#define DS1722_H

#include "STM32L432KC.h"

// Define register addresses
#define WRITE_CONFIG   0x80  
#define READ_CONFIG    0x00  
#define READ_TEMPLSB   0x01  
#define READ_TEMPMSB   0x02  

// Define new functions 
void delayconfig(void);
float updateTemp(int32_t res);
float decodeTemp(uint8_t lsb, uint8_t msb);

#endif // DS1722