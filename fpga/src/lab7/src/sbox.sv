// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the logic for the non-synchronous sbox
// 11/03/25

module sbox(input  logic [7:0] boxreg,
            output logic [7:0] subox);
  logic [7:0] sbox[0:255];

  initial   $readmemh("sbox.txt", sbox);
  assign subox = sbox[boxreg];
endmodule