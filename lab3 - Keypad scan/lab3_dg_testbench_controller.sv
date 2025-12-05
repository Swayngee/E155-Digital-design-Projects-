// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made for the purpose of testing the segment output
// 9/15/25

module lab3_dg_testbench_controller();
logic int_osc, reset;
logic enabler;             
logic alarm;
logic [7:0] keypress;
logic disp1;
logic disp2;
logic [7:0] controller;
integer errors;

lab3_dg_controlseg u_controller(int_osc, reset, enabler, alarm, keypress, disp1, disp2, controller);

logic [7:0] exppast, expcurrent, expcontroller;

always begin
int_osc = 1; #5; 
int_osc = 0; #5;
end

initial begin
errors=0;
reset = 1; #22; 
reset = 0;
keypress = 8'b11011110; alarm = 1'b1; enabler = 1'b1; 
#20;
keypress = 8'b11100111; alarm = 1'b1; enabler = 1'b0; 
#20;
keypress = 8'b10111011; alarm = 1'b1; enabler = 1'b1; 
#20;
#100;
$display("Simulation finished with %0d errors", errors);
$finish;
end

always_ff @(posedge int_osc or posedge reset) begin
    if (reset) begin
        exppast <= 8'd0;
        expcurrent <= 8'd0;
    end else if (alarm == 1'b1) begin
        exppast <= expcurrent;
        expcurrent <= keypress;
		end
end
always_comb begin
    if (reset) begin
        expcontroller = 8'd0;
    end else if (enabler) begin
        expcontroller = expcurrent;
    end else begin
        expcontroller = exppast;
    end

end
always @(negedge int_osc)
if (!reset) begin
	if (disp1 == disp2) begin
		$display(" outputs = %d and %d are the same", disp1, disp2);
		errors = errors + 1;
	end
	if (disp1 && ~disp2 && enabler == 1'b0) begin
		$display(" outputs = enabler = 0 is wrong");
		errors = errors + 1;
	end
	else if (~disp1 && disp2 && enabler == 1'b1) begin
		$display(" outputs = enabler = 1 is wrong");
		errors = errors + 1;
	end
	end


endmodule
