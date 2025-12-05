// Drake Gonzales
// drgonzales@g.hmc.edu
// Module for blinking Led[2:0]. Consists of a HSOSC and simple combinational logic.
// 9/2/25

module lab2_dg_led(input logic [3:0] s,
		   output logic [2:0] led);
		 
   logic int_osc;
   logic [24:0] counter;

  
   // Internal high-speed oscillator
   
   HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
  
   // Counter
   always_ff @(posedge int_osc) begin
		if(counter == 25'd10000000) begin
			led[2] <= ~led[2];
			counter <= 0;
		end
     else            counter <= counter + 25'd1;
   end
  
   // Assign LED output

   assign led[0] = s[1] ^ s[0];
   assign led[1] = s[3] & s[2];

endmodule
