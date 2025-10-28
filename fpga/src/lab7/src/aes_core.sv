/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core(input  logic         int_osc,
                input logic reset,
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);
logic [127:0] sreg;
logic [127:0] subbytes;
logic [127:0] shiftedmatrix;
logic [127:0] mixedcols;
logic [127:0] nextkey;
logic [3:0] counter;
logic [31:0] a;
logic [31:0] y;
logic alarm;
logic complete;

aesrounds a1(int_osc, reset, plaintext, subbytes, shiftedmatrix, mixedcols, nextkey, complete, sreg, counter, alarm, done, sudone, cyphertext);
keyexpansion keys(int_osc, reset, load, key, counter, nextkey, complete);
subbytes bytes(int_osc, reset, sreg, subox, subbytes, boxreg, sudone);
shiftrows rows(sreg, shiftedmatrix);
mixcolumns cols(sreg, alarm, mixedcols);
mixcolumn col(a, alarm, y);
sbox s1(boxreg, subox);

endmodule