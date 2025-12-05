// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the core top module to combine the AES functions
// 11/03/25

module aes_core(input logic int_osc,
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);
//logic int_osc;	
//HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
logic [127:0] sreg;
logic [127:0] subbytes;
logic [127:0] shiftedmatrix;
logic [127:0] mixedcols;
logic [127:0] nextkey;
logic [3:0] counter;
logic [7:0] boxreg, subreg;
logic alarm;
logic complete;
logic add; 
logic byteenable; 
logic rowenable;
logic colenable; 
logic rowsdone; 
logic coldone; 

aesrounds dg_rounds(int_osc, load, plaintext, subbytes, shiftedmatrix, mixedcols, nextkey, complete, rowsdone, coldone, byteenable, rowenable,  colenable, sreg, counter, alarm, done, add,  cyphertext);
keyexpansion dg_keys(int_osc, load, add, key, sreg, counter, nextkey, complete);
subbytes dg_bytes(int_osc, sreg, byteenable, subbytes);
shiftrows dg_rows(int_osc,rowenable, sreg, shiftedmatrix, rowsdone);
mixcolumns dg_cols(int_osc, load, colenable, sreg, alarm, mixedcols, coldone);


endmodule