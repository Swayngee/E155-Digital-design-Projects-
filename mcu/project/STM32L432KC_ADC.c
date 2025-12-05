#include "STM32L432KC_ADC.h"
uint16_t values[3];

void configureADC(void){
    ADC1_COMMON->CCR |= (1 << ADC_CCR_CKMODE_Pos);


    GPIOA->MODER |= (3 << GPIO_MODER_MODE0_Pos) |
                    (3 << GPIO_MODER_MODE1_Pos) |
                    (3 << GPIO_MODER_MODE3_Pos);
    ADC1->CR &= ~ADC_CR_DEEPPWD;  
    ADC1->CR &= ~ADC_CR_ADEN;
    ADC1->CR |= ADC_CR_ADVREGEN;
    for (volatile int i = 0; i < 1000; i++); 

    ADC1->CR |= ADC_CR_ADCAL;
    while (ADC1->CR & ADC_CR_ADCAL);

    ADC1->CFGR &= ~ADC_CFGR_RES;
    // Setting up the different GPIO channels 
    ADC1->DIFSEL &= ~(ADC_DIFSEL_DIFSEL_5 |
                      ADC_DIFSEL_DIFSEL_6 |
                      ADC_DIFSEL_DIFSEL_8);
    ADC1->SMPR1 &= ~(ADC_SMPR1_SMP5 |
                     ADC_SMPR1_SMP6 |
                     ADC_SMPR1_SMP8);

    ADC1->SMPR1 |= (5 << ADC_SMPR1_SMP5_Pos) |
                   (5 << ADC_SMPR1_SMP6_Pos) |
                   (5 << ADC_SMPR1_SMP8_Pos);

    ADC1->SQR1 = (2 << ADC_SQR1_L_Pos) |  
                 (5 << ADC_SQR1_SQ1_Pos) | 
                 (6 << ADC_SQR1_SQ2_Pos) | 
                 (8 << ADC_SQR1_SQ3_Pos);  

    ADC1->ISR |= ADC_ISR_ADRDY;   // clear flag
    ADC1->CR  |= ADC_CR_ADEN;
    while (!(ADC1->ISR & ADC_ISR_ADRDY));  // wait for ready
}


void readADC(void) {
    ADC1->CR |= ADC_CR_ADSTART; 
    while (!(ADC1->ISR & ADC_ISR_EOC));
    values[0] = ADC1->DR;

    while (!(ADC1->ISR & ADC_ISR_EOC));
    values[1] = ADC1->DR;

    while (!(ADC1->ISR & ADC_ISR_EOC));
    values[2] = ADC1->DR;
}
