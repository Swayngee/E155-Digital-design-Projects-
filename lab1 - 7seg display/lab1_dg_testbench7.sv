// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made to run testvectors through a simulation to test the 7-segment design. 
// 9/2/25
module lab1_dg_testbench7();
logic clk, reset;
logic [3:0] s;
logic [6:0] seg, segexpected;
logic [31:0] vectornum, errors;
logic [10:0] testvectors[10000:0];

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
$readmemb("7seg.tv", testvectors);

vectornum=0; 
errors=0;

reset=1; #22; 
 reset=0;

end
//// Apply test vectors on rising edge of clk.
always @(posedge clk)
 
begin

#1;
{s, segexpected} = testvectors[vectornum];
end
//// Check results on falling edge of clk.
always @(negedge clk)

if (~reset) begin

if (seg !== segexpected ) begin

$display("Error: inputs = %b", {s});

$display(" outputs = %b (%b expected)", seg, 
segexpected);
//// Increment the count of errors.
errors = errors + 1;
end
//// In any event, increment the count of vectors.
vectornum = vectornum + 1;

 if (testvectors[vectornum] === 11'bx) begin

$display("%d tests completed with %d errors", vectornum, 
errors);
// Then stop the simulation.
$stop;
end
end

endmodule
