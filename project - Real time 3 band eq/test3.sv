// Simple hardcoded testbench for MAC16_wrapper_accum
// Just set inputs and observe outputs

`timescale 1ns/1ps

module MAC16_wrapper_accum_tb();

logic clk, reset, mac_rst, ce;
logic signed [15:0] a_in, b_in;
logic signed [31:0] result;

// Instantiate DUT
MAC16_wrapper_accum dut(clk, reset, mac_rst, ce, a_in, b_in, result);

// Clock generation - 10ns period (100 MHz)
always begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
    // Initialize
    reset = 0;
    mac_rst = 1;
    ce = 0;
    a_in = 16'h0000;
    b_in = 16'h0000;
    
    #20;
    reset = 1;
    #20;
    
    // Reset accumulator
    mac_rst = 0; #10;
    mac_rst = 1; #10;
    
    // Test 1: 1.0 × 1.0 (0x4000 in Q2.14)
    a_in = 16'h4000;
    b_in = 16'h4000;
    ce = 1; #10;
    ce = 0; #30;
    
    // Test 2: Add 2.0 × 2.0 (0x8000 in Q2.14)  
    a_in = 16'h8000;
    b_in = 16'h8000;
    ce = 1; #10;
    ce = 0; #30;
    
    // Test 3: Reset and try 0.5 × 0.5 (0x2000 in Q2.14)
    mac_rst = 0; #10;
    mac_rst = 1; #10;
    
    a_in = 16'h2000;
    b_in = 16'h2000;
    ce = 1; #10;
    ce = 0; #30;
    
    // Test 4: Biquad coefficients
    mac_rst = 0; #10;
    mac_rst = 1; #10;
    
    a_in = 16'sh0147;  // b0 = 0.020
    b_in = 16'h4000;   // x[n] = 1.0
    ce = 1; #10;
    ce = 0; #30;
    
    a_in = 16'sh028E;  // b1 = 0.040
    b_in = 16'h2000;   // x[n-1] = 0.5
    ce = 1; #10;
    ce = 0; #30;
    
    a_in = 16'sh0147;  // b2 = 0.020
    b_in = 16'h1000;   // x[n-2] = 0.25
    ce = 1; #10;
    ce = 0; #30;
    
    #100;
    $finish;
end

endmodule