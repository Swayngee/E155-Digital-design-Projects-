// The below code was copied from the aes_core_tb originally wrote my Josh Brake
// Was changed for shiftrows inputs and outputs

`timescale 10ns/1ns

module shiftrows_tb();

    logic int_osc, reset;
    logic [127:0] sreg, shiftedmatrix, expected;
    
    // device under test
    shiftrows dut(sreg, shiftedmatrix);
    
    // test case
    initial begin   
    sreg  <= 128'h894D9B03C0B512212E56883C6038534A; // Round two of example AES128 output
    expected  <= 128'h89B5884AC05653032E389B21604D123C;
    #10;

    end
    always begin
			int_osc = 1'b0; #5;
			int_osc = 1'b1; #5;
		end

        // Check result
        if (shiftedmatrix === expected)
            $display("shiftrows output matched expected value.");
        else
            $display("Got %h, expected %h", shiftedmatrix, expected);
        $stop();
        

endmodule