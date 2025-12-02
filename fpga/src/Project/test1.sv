// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made for the purpose of testing our state machine by throwing in input rows
// 9/20/25

module test1();
logic clk, reset, l_r_clk;
logic signed [15:0] b0, b1, b2, a1, a2;
logic signed [15:0] filtered_output;
logic signed [15:0] latest_sample;

iir_time_mux_accum mux(clk, l_r_clk, reset, latest_sample, b0, b1, b2, a1, a2, filtered_output);


always begin
clk = 0;
clk =1; #5; 
clk =0; #5;
end

always begin
l_r_clk = 0;
l_r_clk =1; #10; 
l_r_clk =0; #10;
end

initial begin 
reset=0; #22; 
reset=1;

b0 = 16'sh0147;  // ~0.020 in Q2.14
b1 = 16'sh028E;  // ~0.040 in Q2.14
b2= 16'sh0147;  // ~0.020 in Q2.14
a1= 16'sh6A3D;  // ~1.659 in Q2.14
a2= 16'shD89F;  // ~-0.618 in Q2.14

#20;

b0 = 16'sh0CCC;  // ~0.020 in Q2.14
b1 = 16'sh0000; // ~0.040 in Q2.14
b2 = 16'shF334;  // ~0.020 in Q2.14
a1 = 16'sh5A82;  // ~1.659 in Q2.14
a2 = 16'shE666;  // ~-0.618 in Q2.14
    
#20;

b0 = 16'sh2E8B;  // ~0.020 in Q2.14
b1 = 16'shA2EA; // ~0.040 in Q2.14
b2  = 16'sh2E8B;  // ~0.020 in Q2.14
a1 = 16'shA5C3;  // ~1.659 in Q2.14
a2 = 16'sh1F5C;  // ~-0.618 in Q2.14
	
end

endmodule
