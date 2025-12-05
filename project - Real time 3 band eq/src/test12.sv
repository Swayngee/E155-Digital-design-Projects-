// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made for the purpose of testing our state machine by throwing in input rows
// 9/20/25

module test1();
logic clk, reset, l_r_clk;
logic signed [15:0] audio_in, audio_out;


three_band_eq three(clk, l_r_clk, reset, audio_in, audio_out);


always begin
clk = 0;
clk=1; #5; 
clk=0; #5;
end

always begin
l_r_clk = 0;
l_r_clk=1; #10; 
l_r_clk=0; #10;
end

initial begin 
reset=0; #22; 
reset=1;

audio_in = 16'h2000;  // ~0.020 in Q2.14

#20;

audio_in = 16'h4000;
    
#20;

audio_in = 16'h7FFF;
	
end

endmodule
