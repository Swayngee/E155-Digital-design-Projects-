// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the logic for a synchronous sbox
// 11/03/25
module sbox_sync(
	input		logic [7:0] sboxin,
	input	 	logic 			int_osc,
	output 	logic [7:0] sboxout);
            
  // sbox implemented as a ROM
  // This module is synchronous and will be inferred using BRAMs (Block RAMs)
  logic [7:0] sbox [0:255];

  initial   $readmemh("sbox.txt", sbox);
	
	// Synchronous version
	always_ff @(posedge int_osc) begin
		sboxout <= sbox[sboxin];
	end
endmodule