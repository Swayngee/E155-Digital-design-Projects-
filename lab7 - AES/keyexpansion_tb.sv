// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the testbench for the keyexpansion fsm
// 11/03/25


`timescale 10ns/1ns

module keyexpansion_tb();

    logic int_osc, reset, load, complete;
    logic [127:0] key, nextkey, expected;
    logic [3:0] counter;
    
    // device under test
    keyexpansion dut(int_osc, reset, load, key, counter, nextkey, complete);
always begin
int_osc = 0;
int_osc = 1'b0; #5;
int_osc = 1'b1; #5;
end
initial begin
reset = 0; #12;
reset =1;  
end
    initial begin
      load = 1'b1; #22; load = 1'b0; //Pulse load to start conversion
    end

    initial begin   
    key  <= 128'h2B7E151628AED2A6ABF7158809CF4F3C;
    counter <= 4'd0;
    expected  <= 128'h2B7E151628AED2A6ABF7158809CF4F3C;
#10;
      if (complete) begin
        if (nextkey == expected)
            $display("Testbench ran successfully");
        else $display("Error: key = %h, expected %h",
            nextkey, expected);
        $stop;
      end
    end
  
endmodule