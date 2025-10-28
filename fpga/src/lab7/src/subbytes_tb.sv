// The below code was copied from the aes_core_tb originally wrote my Josh Brake
// Was changed for subbytes inputs and outputs

`timescale 10ns/1ns

module subbytes_tb();

    logic int_osc, reset;
    logic [127:0] sreg, subbytes, expected;
    
    // device under test
    subbytes dut(sreg, subbytes);
    
    // test case
    initial begin   
    sreg  <= 128'h40BFABF406EE4D3042CA6B997A5C5816 ;
    expected  <= 128'h090862BF6F28E3042C747FEEDA4A6A47;
    #10;

    end
    always begin
			int_osc = 1'b0; #5;
			int_osc = 1'b1; #5;
		end

        // Check result
        if (subbytes === expected)
            $display("SubBytes output matched expected value.");
        else
            $display("Got %h, expected %h", subbytes, expected);
        $stop();

endmodule
