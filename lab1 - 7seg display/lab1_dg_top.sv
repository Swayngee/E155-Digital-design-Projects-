// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was used as a top module for he overall design. Having calling two different functions,
// The purpose of this module is to combine other modules into one larger projeect. 

module lab1_dg_top(input logic [3:0] s,
		   output logic [6:0] seg,
		   output logic [2:0] led);
		   
lab1_dg_led u_led(s, led);
lab1_dg_segment u_segment(s, seg);
endmodule



		
