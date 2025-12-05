// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made for the purpose of testing our synchronizer
// 9/20/25

module lab3_dg_testbench_sync();
logic int_osc, reset;
logic [3:0] rowpress;
logic [3:0] sync;	

lab3_dg_sync u_sync(int_osc, ~reset, rowpress, sync);
 
logic [3:0] exp, n1;
always
begin
int_osc=1; #5; 
int_osc=0; #5;
end
initial begin
reset = 1; #22;   
reset = 0;
rowpress = 4'b0000; #20;
rowpress = 4'b1001; #20;
rowpress = 4'b1111; #20;
end

    always_ff @(posedge int_osc or posedge reset) begin
        if (reset) begin
            exp <= 4'b0000;
            n1 <= 4'b0000;
        end else begin
            n1 <= rowpress;
            exp <= n1;
            assert (sync == exp)
                else $error("sync mismatch");
        end
    end
    initial begin
        
    end

endmodule
