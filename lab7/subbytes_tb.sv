// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module is the testbench to test our subbytes module
// 11/03/25

module subbytes_tb();

logic int_osc, reset, byteenable;
logic [127:0] sreg, subbytes, expected;
    
    // device under test
    subbytes dut(int_osc, sreg, byteenable, subbytes);
always begin
int_osc = 0;
int_osc = 1; #5;
int_osc = 0; #5;
end

    // test case
    initial begin   
	byteenable <= 0; #5
    sreg  <= 128'h40BFABF406EE4D3042CA6B997A5C5816;
	byteenable <= 1;
    expected  <= 128'h090862BF6F28E3042C747FEEDA4A6A47;
    #10;
        // Check result
        if (subbytes === expected)
            $display("SubBytes output matched expected value.");
        else
            $display("Got %h, expected %h", subbytes, expected);
        $stop;
end

endmodule
