#include "STM32L432KC_ADC.h"

uint16_t values[6];   // <-- Now 6 ADC inputs

void configureADC(void) 
{
    // ----- Enable Clocks -----
    ADC1_COMMON->CCR |= (1 << ADC_CCR_CKMODE_Pos);

    // GPIO analog (PA0, PA1, PA3, PA4, PA5, PC0)
    GPIOA->MODER |= (3 << GPIO_MODER_MODE0_Pos) |
                    (3 << GPIO_MODER_MODE1_Pos) |
                    (3 << GPIO_MODER_MODE3_Pos) |
                    (3 << GPIO_MODER_MODE4_Pos) |
                    (3 << GPIO_MODER_MODE5_Pos);

    GPIOC->MODER |= (3 << GPIO_MODER_MODE0_Pos);   // PC0 = CH1

    // ----- Power up ADC -----
    ADC1->CR &= ~ADC_CR_DEEPPWD;
    ADC1->CR &= ~ADC_CR_ADEN;
    ADC1->CR |= ADC_CR_ADVREGEN;

    for (volatile int i = 0; i < 1000; i++);

    // ----- Calibration -----
    ADC1->CR |= ADC_CR_ADCAL;
    while (ADC1->CR & ADC_CR_ADCAL);

    // Resolution: 12-bit (default)
    ADC1->CFGR &= ~ADC_CFGR_RES;

    // Use single-ended for all 6 channels
    ADC1->DIFSEL &= ~(ADC_DIFSEL_DIFSEL_1  |
                      ADC_DIFSEL_DIFSEL_5  |
                      ADC_DIFSEL_DIFSEL_6  |
                      ADC_DIFSEL_DIFSEL_8  |
                      ADC_DIFSEL_DIFSEL_9  |
                      ADC_DIFSEL_DIFSEL_10);

    // Sampling time (set all to SMP=5)
    ADC1->SMPR1 |= (5 << ADC_SMPR1_SMP1_Pos) |
                   (5 << ADC_SMPR1_SMP5_Pos) |
                   (5 << ADC_SMPR1_SMP6_Pos) |
                   (5 << ADC_SMPR1_SMP8_Pos) |
                   (5 << ADC_SMPR1_SMP9_Pos);

    ADC1->SMPR2 |= (5 << ADC_SMPR2_SMP10_Pos);

    // ----- Conversion Sequence (6 total) -----
    //
    // SQ1 = CH5   (PA0)
    // SQ2 = CH6   (PA1)
    // SQ3 = CH8   (PA3)
    // SQ4 = CH9   (PA4)
    // SQ5 = CH10  (PA5)
    // SQ6 = CH1   (PC0)
    //
    ADC1->SQR1 = (5 << ADC_SQR1_L_Pos) |    // length = 6-1 = 5
                 (5 << ADC_SQR1_SQ1_Pos) |
                 (6 << ADC_SQR1_SQ2_Pos) |
                 (8 << ADC_SQR1_SQ3_Pos) |
                 (9 << ADC_SQR1_SQ4_Pos);

    ADC1->SQR2 = (10 << ADC_SQR2_SQ5_Pos) |
                 (1  << ADC_SQR2_SQ6_Pos);

    // ----- Enable ADC -----
    ADC1->ISR |= ADC_ISR_ADRDY;
    ADC1->CR  |= ADC_CR_ADEN;
    while (!(ADC1->ISR & ADC_ISR_ADRDY));
}

void readADC(void)
{
    ADC1->CR |= ADC_CR_ADSTART;

    for (int i = 0; i < 6; i++) {
        while (!(ADC1->ISR & ADC_ISR_EOC));
        values[i] = ADC1->DR;
    }
}
