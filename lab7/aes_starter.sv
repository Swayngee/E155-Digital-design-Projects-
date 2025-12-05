// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module combines all of our previous modules. Here is our very top module
// 11/03/25

module aes_starter(//input logic int_osc,
			input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
                    
    logic [127:0] key, plaintext, cyphertext;
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	//logic reset;
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(int_osc,load, key, plaintext, done, cyphertext);
endmodule
