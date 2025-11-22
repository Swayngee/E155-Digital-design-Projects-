// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module is a SPI configuration C file
// 10/21/25

#include "STM32L432KC.h"
#include "STM32L432KC_SPI.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_RCC.h"

/* Enables the SPI peripheral and intializes its clock speed (baud rate), polarity, and phase.
 *    -- br: (0b000 - 0b111). The SPI clk will be the master clock / 2^(BR+1).
 *    -- cpol: clock polarity (0: inactive state is logical 0, 1: inactive state is logical 1).
 *    -- cpha: clock phase (0: data captured on leading edge of clk and changed on next edge, 
 *          1: data changed on leading edge of clk and captured on next edge)
 * Refer to the datasheet for more low-level details. */ 

void initSPI(int br, int cpol, int cpha) {

    // Disables the SPI for Configuration
    SPI1->CR1 |= (SPI_CR1_SPE); 

    // Enable GPIOA and B
    RCC -> AHB2ENR |= (RCC_AHB2ENR_GPIOAEN);
    RCC -> AHB2ENR |= (RCC_AHB2ENR_GPIOBEN);
    
    // Initialize the SPI clk domain
    RCC->APB2ENR |= RCC_APB2ENR_SPI1EN;

    // Initially assigning SPI pins
    pinMode(SCK, GPIO_ALT); // SCK -> PB3
    pinMode(MISO, GPIO_ALT); // MISO -> PB4
    pinMode(MOSI, GPIO_ALT); // MOSI -> PB5
    pinMode(CE, GPIO_OUTPUT); // CS -> PA11

    // Configure Alt functions for SCK, MSIO, MOSI
    GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL3, 5);
    GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL4, 5);
    GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL5, 5);
    
    // Baud rate divisor
    SPI1->CR1 |= _VAL2FLD(SPI_CR1_BR, br); 

    // Enables MC as Master
    SPI1->CR1 |= (SPI_CR1_MSTR); 
    // Clear bits before setting
    SPI1->CR1 &= ~(SPI_CR1_CPOL_Msk | SPI_CR1_CPHA_Msk ); 
    SPI1->CR1 &= ~(SPI_CR1_SSM |SPI_CR1_LSBFIRST);  
    // Sets clock polarity as cpol
    SPI1->CR1 |= (cpol << SPI_CR1_CPOL_Pos); 
    // Sets the clock phase as cpha 
    SPI1->CR1 |= (cpha << SPI_CR1_CPHA_Pos); 
    // Sets data size to 8 bits
    SPI1->CR2 |= (0b111 << SPI_CR2_DS_Pos); 
    SPI1->CR2 |= (SPI_CR2_FRXTH | SPI_CR2_SSOE);

    // Enable SPI
    SPI1->CR1 |= (SPI_CR1_SPE); 
}

/* Transmits a character (1 byte) over SPI and returns the received character.
 *    -- send: the character to send over SPI
 *    -- return: the character received over SPI */
char spiSendReceive(char send) {
    // Wait for TX to be full
    while(!(SPI1->SR & SPI_SR_TXE)); 
    // Send message
    *(volatile char *) (&SPI1->DR) = send; 
    // Wait for message
    while(!(SPI1->SR & SPI_SR_RXNE)); 
    // Return received message
    char received = (volatile char) SPI1->DR;
    return received; 
}



