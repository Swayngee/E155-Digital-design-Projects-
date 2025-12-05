// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the shiftrows module for the AES
// 11/03/25

module shiftrows(input  logic        int_osc,             
					input  logic rowenable,   
					input  logic [127:0] sreg,      
					output logic [127:0] shiftedmatrix,
					output logic rowsdone);

always_ff @(posedge int_osc) begin
	if (rowenable) begin
        shiftedmatrix[127:120] <= sreg[127:120];
        shiftedmatrix[95:88]   <= sreg[95:88];
        shiftedmatrix[63:56]   <= sreg[63:56];
        shiftedmatrix[31:24]   <= sreg[31:24];

        shiftedmatrix[119:112] <= sreg[87:80];
        shiftedmatrix[87:80]   <= sreg[55:48];
        shiftedmatrix[55:48]   <= sreg[23:16];
        shiftedmatrix[23:16]   <= sreg[119:112];

        shiftedmatrix[111:104] <= sreg[47:40];
        shiftedmatrix[79:72]   <= sreg[15:8];
        shiftedmatrix[47:40]   <= sreg[111:104];
        shiftedmatrix[15:8]    <= sreg[79:72];

        shiftedmatrix[103:96]  <= sreg[7:0];
        shiftedmatrix[71:64]   <= sreg[103:96];
        shiftedmatrix[39:32]   <= sreg[71:64];
        shiftedmatrix[7:0]     <= sreg[39:32];

        rowsdone <= 1'b1; 
    end
    else begin
        rowsdone <= 1'b0; 
    end
end

endmodule
