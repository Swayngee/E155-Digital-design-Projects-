// Drake Gonzales
// drgonzales@g.hmc.edu
// Module for controling the sub-modules. Also initializing the HSOSC
// 9/20/25
module lab3_dg_top(input logic reset, 
					input logic [3:0] rows,
                    output logic [3:0] cols, 
                    output logic [6:0] seg,
                     output logic disp1,
					 output logic disp2);

logic int_osc;
logic [20:0] counter;
logic [7:0] keypress;
logic enabler = 1'b0; 
logic [3:0] sync;   
logic alarm;                 
logic [7:0] controller;       


HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

// clock divider
always_ff @(posedge int_osc) begin
if (~reset) begin
	counter <= 0;
end else begin
	if (counter == 21'd100000) begin
    counter <= 0;
    enabler <= ~enabler;
	end
    else counter <= counter + 21'd1;
end
end

lab3_dg_state u_state(int_osc, reset, sync, cols, keypress, alarm);

lab3_dg_seg u_seg(controller,seg);

lab3_dg_sync u_sync(int_osc, reset, rows, sync);

lab3_dg_controlseg u_control(int_osc, reset, enabler, alarm, keypress, disp1,disp2, controller);


endmodule