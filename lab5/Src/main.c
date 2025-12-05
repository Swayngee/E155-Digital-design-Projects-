//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my main file for lab5
//1/4/25

#include "main.h"
#include "STM32L432KC.h"
//init vars
volatile uint32_t rev = 0;
int dir = 0;
float zero =0;
int32_t prev = 0;
float revolutions =0;
int32_t d =0;
int32_t timer = 500;
int main(void){
GPIOenable(); //init funcs
timenable();
inintAB();

while(1){
// In main loop
d = position;
position = 0; //reset pos each 1Hz print to not add values
revolutions = (float) (d *(1000/timer)) / (4 * 408);  //408 PPR

if (d > 0) dir = 1; //set directions
else if (d < 0) dir = -1;
else dir = 0;

delay_millis(TIM2, timer); //1Hz delay

if (dir == 1) { //print based on direction
    printf("Speed = %f rev/s, Direction = CW\n", revolutions);
} else if (dir == -1) {
    printf("Speed = %f rev/s, Direction = CCW\n", -revolutions);
}

else {
printf("Speed = %f rev/s, Direction = none\n", zero); //zero case
}
}
}


