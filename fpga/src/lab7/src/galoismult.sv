// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the logic for galoismult
// 11/03/25

module galoismult(input  logic [7:0] j,
                  output logic [7:0] k);

    logic [7:0] ashift;
    
    assign ashift = {j[6:0], 1'b0};
    assign k = j[7] ? (ashift ^ 8'b00011011) : ashift;
endmodule