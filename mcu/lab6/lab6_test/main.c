// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module is my main file for Lab 6
// 10/21/25

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "main.h"
static uint8_t config = 0b11100010;
static int led_status = 0;

//Defining the web page in two chunks: everything before the current time, and everything after the current time
char* webpageStart =
"<!DOCTYPE html><html><head><title>E155 IoT webpage</title>"
"<meta charset=\"UTF-8\">"
"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
"</head>"
"<body><h1>E155 IoT webpage</h1>";
char* ledStr =
"<h2>LED Control</h2>"
"<form action=\"ledon\"><input type=\"submit\" value=\"Turn the LED on!\"></form>"
"<form action=\"ledoff\"><input type=\"submit\" value=\"Turn the LED off!\"></form>";

char* resStr = "<p>Temperature Resolution Control:</p><form action=\"8bit\"><input type=\"submit\" value=\"8 Bit!\"></form>\
	<form action=\"9bit\"><input type=\"submit\" value=\"9 Bit!\"></form>\
        <form action=\"10bit\"><input type=\"submit\" value=\"10 Bit!\"></form>\
        <form action=\"11bit\"><input type=\"submit\" value=\"11 Bit!\"></form>\
        <form action=\"12bit\"><input type=\"submit\" value=\"12 Bit!\"></form>";

char* webpageEnd = "</body></html>";

// Determines whether a given character sequence is in a char array request, returning 1 if present, -1 if not present
int inString(char request[], char des[]) {
	if (strstr(request, des) != NULL) {return 1;}
	return -1;
}

int updateLEDStatus(char request[]){
	
	// The request has been received. now process to determine whether to turn the LED on or off
	if (inString(request, "ledoff")==1) {
		digitalWrite(LED_PIN, PIO_LOW);
		led_status = 0;
	}
	else if (inString(request, "ledon")==1) {
		digitalWrite(LED_PIN, PIO_HIGH);
		led_status = 1;
	}

	return led_status;
}

// Checks for resolution updates from webpage
// Returns a call for a function for sensor configuration
float updateConfig(char request[]){
    if (inString(request, "8bit")==1) config = 0b11100000;
    else if (inString(request, "9bit")==1) config = 0b11100010;
    else if (inString(request, "10bit")==1) config = 0b11100100;
    else if (inString(request, "11bit")==1) config = 0b11100110;
    else if (inString(request, "12bit")==1) config = 0b11101110;
    return updateTemp(config);
}


int main(void) {
  configureFlash();
  configureClock();

  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);
  gpioEnable(GPIO_PORT_C);
  pinMode(PB1, GPIO_OUTPUT);
  
  USART_TypeDef * USART = initUSART(USART1_ID, 125000);

  initSPI(0b1111111, 0,1);

  while(1) {
   char request[BUFF_LEN] = "                  "; // initialize to known value
    int charIndex = 0;
  
    // Keep going until you get end of line character
    while(inString(request, "\n") == -1) {
      // Wait for a complete request to be transmitted before processing
      while(!(USART->ISR & USART_ISR_RXNE));
      request[charIndex++] = readChar(USART);
    }
    // Check for resolution updates or refreshes
   float temp = updateConfig(request);

    // Update str with current resolution
    char ledStatusStr[20];
    int led_status = updateLEDStatus(request);
    if (led_status == 1)
      sprintf(ledStatusStr,"LED is on!");
    else if (led_status == 0)
      sprintf(ledStatusStr,"LED is off!");

    // Update str with current resolution
    char tempStr[50];
    sprintf(tempStr, "Temperature: %.5f &deg;C", temp);

    // Finally, transmit the webpage over UART
    sendString(USART, webpageStart);      // webpage header
    sendString(USART, ledStr);            // LED control buttons
    sendString(USART, "<h2>LED Status</h2><p>");
    sendString(USART, ledStatusStr);      
    sendString(USART, "</p>");
    sendString(USART, resStr);            // Resolution control buttons
    sendString(USART, "<h2>Temperature</h2><p>");
    sendString(USART, tempStr);           // Temperature output 
    sendString(USART, "</p>");
    sendString(USART, webpageEnd);
}
}
