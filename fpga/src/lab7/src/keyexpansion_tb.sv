// The below code was copied from the aes_core_tb originally wrote my Josh Brake
// Was changed for keyexpansion inputs and outputs

`timescale 10ns/1ns

module keyexpansion_tb();

    logic int_osc, reset, load, complete;
    logic [127:0] key, nextkey, expected;
    logic [3:0] counter;
    
    // device under test
    keyexpansion dut(int_osc, reset, load, key, counter, nextkey, complete);
    
    // test case
    initial begin   
    key  <= 128'h2B7E151628AED2A6ABF7158809CF4F3C;
    expected  <= 128'h2B7E151628AED2A6ABF7158809CF4F3C;

    end
    always begin
			int_osc = 1'b0; #5;
			int_osc = 1'b1; #5;
		end
        
    initial begin
      load = 1'b1; #22; load = 1'b0; //Pulse load to start conversion
    end

    always @(posedge int_osc) begin
      if (complete) begin
        if (nextkey == expected)
            $display("Testbench ran successfully");
        else $display("Error: key = %h, expected %h",
            nextkey, expected);
        $stop();
      end
    end
    
endmodule