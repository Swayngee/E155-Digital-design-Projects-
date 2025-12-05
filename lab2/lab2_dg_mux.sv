// Drake Gonzales
// drgonzales@g.hmc.edu
// Module for controlling the mux
// 9/4/25
module lab2_dg_mux(input logic [3:0] s1,
                    input logic [3:0] s2,
					input logic enabler,
                    output logic disp1,
					output logic disp2,
                    output logic [3:0] mux);

	always_comb begin
		if (enabler ==1'b0) begin
			disp1 = 1'b1;
			disp2 = 1'b0;
			mux = s1;
		end
		else begin
			disp1 = 1'b0;
			disp2 = 1'b1;
			mux = s2;
		end 
	end

endmodule