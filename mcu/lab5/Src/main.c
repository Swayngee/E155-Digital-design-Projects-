

#include "INITMAIN.h"
#include "STM32L432KC.h"

volatile uint32_t rev = 0;
int dir = 0;


int main(void){
GPIOenable();
inintAB();

while(1){

if (countA < 0) dir = 1;  
else if (countB < 0) dir = -1;  

if (countA  >= 7 || countB >= 7){
rev = rev + 1;
countA = 0;
countB = 0;
}

delay_millis(TIM7, 1000); 
if (dir == 1) {
    printf("Speed = %u rev/s, Direction = CW\n", rev);
} else if (dir == -1) {
    printf("Speed = %u rev/s, Direction = CCW\n", rev);
}
rev = 0;

}
}

