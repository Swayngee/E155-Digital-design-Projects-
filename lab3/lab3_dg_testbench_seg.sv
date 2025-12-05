// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made to run testvectors through a simulation to test the 7-segment design. 
// 9/20/25

module lab3_dg_testbench_seg();
logic clk, reset;
logic [7:0] controller;
logic [6:0] seg, segexpected;
logic [31:0] vectornum, errors;
logic [14:0] testvectors[10000:0];

lab3_dg_seg u_segment(controller, seg);
//// Generate clock for the segment
always
begin
clk=1; #5; 
clk=0; #5;
end
//// Start of test. 
initial
// 'initial' is used only in testbench simulation.
begin
//// Load vectors stored as 0s and 1s (binary) in .tv file.
$readmemb("keys.tv", testvectors);

vectornum=0; 
errors=0;

reset=1; #22; 
 reset=0;

end
//// Apply test vectors on rising edge of clk.
always @(posedge clk)
 
begin

#1;
{controller, segexpected} = testvectors[vectornum];
end
//// Check results on falling edge of clk.
always @(negedge clk)

if (~reset) begin

if (seg !== segexpected ) begin

$display("Error: inputs = %b", {controller});

$display(" outputs = %b (%b expected)", seg, 
segexpected);
//// Increment the count of errors.
errors = errors + 1;
end
//// In any event, increment the count of vectors.
vectornum = vectornum + 1;

 if (testvectors[vectornum] === 15'bx) begin

$display("%d tests completed with %d errors", vectornum, 
errors);
// Then stop the simulation.
$stop;
end
end

endmodule
