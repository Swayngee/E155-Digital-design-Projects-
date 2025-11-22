// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module is a SPI configuration header file
// 10/21/25

#ifndef STM32L432KC_SPI_H
#define STM32L432KC_SPI_H

#include <stdint.h>
#include <stm32l432xx.h>

// Define SPI register pins
#define CE PA11
#define SCK PB3
#define MOSI PB5
#define MISO PB4

// Define new functions
void initSPI(int br, int cpol, int cpha);
char spiSendReceive(char send);

#endif