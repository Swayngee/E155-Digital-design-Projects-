// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the testbench for the AES rounds
// 11/03/25

module aesrounds_tb();
logic int_osc, reset;
logic [127:0] plaintext, subbytes, shiftedmatrix, mixedcols, nextkey, cyphertext, sreg;
logic complete, alarm, done, sudone;
logic [3:0] counter;
logic [31:0] vectornum, errors;

aesrounds u_state(int_osc, reset, plaintext, subbytes, shiftedmatrix, mixedcols, nextkey, complete, sudone, sreg, counter, alarm, done, cyphertext);

always
begin
int_osc = 0;
int_osc=1; #5; 
int_osc=0; #5;
end
initial
begin 
reset=0; #22; 
reset=1;
errors = 0;

// This code is used to check if rounds were set right. And if the state register latches correctly. 

plaintext <= 128'h6BC1BEE22E409F96E93D7E117393172A;
nextkey <= 128'h40BFABF406EE4D3042CA6B997A5C5816;
@(posedge int_osc);
repeat (10) begin
complete <= 1;
sudone <= 1; 
    subbytes      <= 128'h090862BF6F28E3042C747FEEDA4A6A47;
    shiftedmatrix <= 128'h09287F476F746ABF2C4A6204DA08E3EE;
    mixedcols     <= 128'h529F16C2978615CAE01AAE54BA1A2659;
@(posedge int_osc);
end
end
endmodule
