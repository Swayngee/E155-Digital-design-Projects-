// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made for the purpose of testing the LED module. This runs test vectors for Led[1:0].
// 9/2/25

module lab1_dg_testbenchled();
logic clk, reset;
logic [3:0] s;
logic [1:0] led, ledexpected;
logic [31:0] vectornum, errors;
logic [5:0] testvectors[10000:0];

lab1_dg_led u_led(s, led);
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
$readmemb("led.tv", testvectors);
vectornum=0; 
errors=0;
reset=1; #22; 
reset=0;
end
//// Apply test vectors on rising edge of clk.
always @(posedge clk)
begin
#1;
{s, ledexpected} = testvectors[vectornum];
end
//// Check results on falling edge of clk.
always @(negedge clk)
if (~reset) begin
if (led !== ledexpected) begin
$display("Error: inputs = %b", {s});
$display(" outputs = %b (%b expected)", led, ledexpected);
errors = errors + 1;
end
vectornum = vectornum + 1;
 if (testvectors[vectornum] === 6'bx) begin
$display("%d tests completed with %d errors", vectornum, 
errors);
$stop;
end
end

endmodule
