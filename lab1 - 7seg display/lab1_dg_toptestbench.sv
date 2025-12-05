// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module had the purpose of testing out top module. It combines the two
// testvectors from the other modules and runs them to confirm the right flow. 
// 9/2/25


module lab1_dg_testbenchled();
logic clk, reset;

logic [3:0] s;
logic [1:0] led, ledexpected;
logic [6:0] seg, segexpected;
// These variables or signals represent 3 inputs, 2 outputs, 2 expected 
// outputs, respectively.
logic [31:0] vectornum, errors;
logic [15:0] testvectors[10000:0];

lab1_dg_led u_led(s, led);
lab1_dg_segment u_segment(s, seg);
//// Generate clock.
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
$readmemb("toptestvector.tv", testvectors);
vectornum=0; 
errors=0;
reset=1; #22; 
reset=0;
end
//// Apply test vectors on rising edge of clk.
always @(posedge clk)
begin
#1;
{s, segexpected, ledexpected} = testvectors[vectornum];
end
//// Check results on falling edge of clk.
always @(negedge clk)
if (~reset) begin
if (seg !== segexpected || led!= ledexpected) begin
$display("Error: inputs = %b", {s});
$display(" outputs = %b %b(%b %b expected)", seg, 
segexpected, led, ledexpected);
errors = errors + 1;
end
vectornum = vectornum + 1;
if (testvectors[vectornum] === 16'bx) begin
$display("%d tests completed with %d errors", vectornum, 
errors);
$stop;
end
end
endmodule