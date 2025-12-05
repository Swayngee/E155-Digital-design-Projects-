// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module calls mixcol and applies it to multiple collumns 
// 11/03/25

module mixcolumns(
    input  logic        int_osc,
    input logic         load, 
    input  logic        colenable,
    input  logic [127:0] sreg,
    input  logic        alarm,
    output logic [127:0] mixedcols,
    output logic        coldone);

    logic [31:0] col0, col1, col2, col3;


    mixcolumn mc0 (sreg[127:96], alarm, col0);
    mixcolumn mc1 (sreg[95:64],  alarm, col1);
    mixcolumn mc2 (sreg[63:32],  alarm, col2);
    mixcolumn mc3 (sreg[31:0],   alarm, col3);

    // Sequential logic to latch outputs
    always_ff @(posedge int_osc) begin
        if (load) begin
            mixedcols <= 128'b0;
            coldone   <= 1'b0;
        end
        else if (colenable) begin
            // latch outputs from mixcolumns
            mixedcols <= {col0, col1, col2, col3};
            coldone   <= 1'b1;
        end
        else begin
            coldone <= 1'b0;
        end
    end

endmodule