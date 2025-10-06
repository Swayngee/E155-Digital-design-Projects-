//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my main file for lab5
//1/4/25
    

#include "INITMAIN.h"
#include "STM32L432KC.h"

volatile uint32_t rev = 0;
int dir = 0;
double zero =0;

int main(void){
GPIOenable();
inintAB();

while(1){
int32_t prev = 0;
double revolutions =0;
int32_t d = position - prev;
prev = position;
revolutions = (double)d / 1632.0;  

if (d > 0) dir = 1;
else if (d < 0) dir = -1;
else dir = 0;

delay_millis(TIM7, 1000); 
if (dir == 1) {
    printf("Speed = %.2f rev/s, Direction = CW\n", revolutions);
} else if (dir == -1) {
    printf("Speed = %.2f rev/s, Direction = CCW\n", revolutions);
}
else {
    printf("Speed = %.2f rev/s, Direction = unknown\n", zero);
}


}
}


