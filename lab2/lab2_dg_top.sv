// Drake Gonzales
// drgonzales@g.hmc.edu
// Module for controling the sub-modules. Also initializing the HSOSC
// 9/4/25
module lab2_dg_top(input logic reset, 
					input logic [3:0] s1,
                     input logic [3:0] s2,
                     output logic [6:0] seg,
                     output logic disp1,
					 output logic disp2,
                     output logic [4:0] led);

HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

logic int_osc;
logic enabler = 1'b0;
logic [3:0] mux;
logic [20:0] counter;

// clock divider
always_ff @(posedge int_osc) begin
if (~reset) begin
	counter <= 0;
	enabler <= 1'b0;
end else begin
	if (counter == 19'd100000) begin
	enabler <= ~enabler; 
    counter <= 0;
	end
    else            counter <= counter + 19'd1;
end
end
 
lab2_dg_mux u_mux(s1, s2, enabler, disp1, disp2, mux);

lab2_dg_seg u_seg(mux, seg);

lab2_dg_led_adder u_adder(s1, s2, led);


endmodule