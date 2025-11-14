module top( input logic reset,       
            input  logic in,         
            output logic sysclk,     
            output logic dout,       
            output logic bclk,        
            output logic  lrclk);

logic [5:0]  sampleres  = 6'd16;
logic [9:0]  clkdiv     = 10'd21;
logic        sampleorder = 1'b0;
logic        enabler     = 1'b1;

logic [31:0] i2din;      
logic [31:0] i2dout;             
logic        buffer;
logic bypass = 1'd1; 

HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(sysclk));

assign i2din = i2dout;

lscc_i2s_codec #(
    .DATA_WIDTH       (16),
    .TRANSCEIVER_MODE (0)
) I2S (
    .reset       (reset),
    .sysclk      (sysclk),
    .sampleres   (sampleres),
    .clkdiv      (clkdiv),
    .sampleorder (sampleorder),
    .enabler     (enabler),
    .din         (in),
    .i2din       (i2din),
    .i2dout      (i2dout),
    .buffer      (buffer),
    .dout        (dout),
    .bclk        (bclk),
    .lrclk       (lrclk));

endmodule