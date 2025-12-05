// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the testbench for our switchrows module
// 11/03/25

`timescale 10ns/1ns

module shiftrows_tb();

    logic int_osc, reset;
    logic [127:0] sreg, shiftedmatrix, expected;
    
    // device under test
    shiftrows dut(sreg, shiftedmatrix);
always begin
int_osc = 1'b0; #5;
int_osc = 1'b1; #5;
end
initial begin
reset = 1; #22
reset = 0;
end

    // test case
    initial begin   
    sreg  = 128'h894D9B03C0B512212E56883C6038534A; // Round two of example AES128 output
    expected  = 128'h89B5884AC05653032E389B21604D123C;
    #10;

 
        // Check result
        if (shiftedmatrix === expected)
            $display("shiftrows output matched expected value.");
        else
            $display("Got %h, expected %h", shiftedmatrix, expected);
        $stop;
end
        

endmodule