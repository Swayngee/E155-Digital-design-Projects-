// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds synchronzer for my fsm
// 9/20/25
module lab3_dg_sync(input logic int_osc,
					input logic reset,
                    input logic [3:0] rows,
                    output logic [3:0] sync);
logic [3:0] n1;

always_ff @(posedge int_osc) begin
    if (~reset) begin
        n1   <= 4'b1111;
        sync <= 4'b1111;
    end else begin
        n1 <= rows;
        sync <= n1;
    end
end
endmodule



