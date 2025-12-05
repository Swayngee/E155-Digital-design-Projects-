// Drake Gonzales
// drgonzales@g.hmc.edu
// Module for blinking Led[4:0]. Consists of a simple adder
// 9/4/25

module lab2_dg_led_adder(input logic [3:0] s1,
                   input logic [3:0] s2,
                   output logic [4:0] led);

 assign led = s1 + s2;

endmodule