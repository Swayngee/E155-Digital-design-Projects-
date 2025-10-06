//Drake Gonzales
//drgonzales@g.hmc.edu
//This Module is my main file for lab5
//1/4/25
    

#include "INITMAIN.h"
#include "STM32L432KC.h"

volatile uint32_t rev = 0;
int dir = 0;
double revolutions =0;
double zero =0;

int main(void){
GPIOenable();
inintAB();

while(1){

if (position > 0) {
    dir = 1;
} else if (position < 0) {
    dir = -1;
}

if (position  != 0){
revolutions += position /7.0;

  if(position >= 7){
    position = 0;
  }
}

delay_millis(TIM7, 1000); 
if (dir == 1) {
    printf("Speed = %.2f rev/s, Direction = CW\n", revolutions);
} else if (dir == -1) {
    printf("Speed = %.2f rev/s, Direction = CCW\n", revolutions);
}
else {
    printf("Speed = %.2f rev/s, Direction = unknown\n", zero);
}

revolutions = 0;

}
}


