`timescale 1ns / 10ps

module lscc_i2s_codec #
  (
    parameter DATA_WIDTH  = 16,
    parameter TRANSCEIVER_MODE = 0
  )
  (
    reset,
    sysclk,
    sampleres,
    clkdiv,
    sampleorder,
    enabler,
    din,
    i2din,
    i2dout,
    buffer,
    dout,
    bclk,
    lrclk
   );

input                      reset;     //-- Reset
input                      sysclk;    //-- LMMI clock
input              [5 : 0] sampleres;    //-- sample resolution
input              [9 : 0] clkdiv;  //-- clock divider ratio
input                      sampleorder;   //-- left/right sample order
input                      enabler;     //-- transmitter/recevier enable
input                      din;      //-- I2S serial data input
input             [31 : 0] i2din;  //-- audio data // Input from ADC
output            [31 : 0] i2dout;  //-- audio data // Output to  DAC
output                     buffer;    //-- sample buffer read/write
output                     dout;      //-- I2S serial data output
output                     bclk;     //-- I2S clock output // bitclock
output                     lrclk;      //-- I2S word select output // LRCLK

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam IDLE     = 0;
localparam WAIT_CLK = 1;
localparam TRX_DATA = 2;
localparam RX_WRITE = 3;
localparam SYNC     = 4;

// -----------------------------------------------------------------------------
// Sequential Registers
// -----------------------------------------------------------------------------
reg                      clkenable;
reg              [9 : 0] clkcount;
reg              [4 : 0] sd_ctrl_r;
reg              [4 : 0] bclkcount, txrx; //integer range 0 to 63;
reg                      toggle,negedge, lrclkposedge,lrclknegedge;
reg [DATA_WIDTH - 1 : 0] datainreg;// (DATA_WIDTH - 1 downto 0);
reg                      lrclkreg, newword;
reg                      memdrwr;
reg              [4 : 0] lrclkcount; // integer range 0 to 31;

reg                      sendreg;

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
wire             [5 : 0] conf_res_w;
wire             [9 : 0] conf_ratio_w;
wire                     conf_swap_w;
wire                     conf_en_w;
wire                     receiver_w;

// -----------------------------------------------------------------------------
// Assign Statements
// -----------------------------------------------------------------------------
assign dout     = sendreg;
assign conf_res_w   = sampleres;
assign conf_ratio_w = clkdiv;
assign conf_swap_w  = sampleorder;
assign conf_en_w    = enabler;

assign receiver_w = (TRANSCEIVER_MODE==1)? 1'b1:1'b0;

assign bclk = toggle;

assign  buffer   = memdrwr;
assign  i2dout = {{(32-DATA_WIDTH){1'b0}}, datainreg};

// -----------------------------------------------------------------------------
// Sequential Blocks
// -----------------------------------------------------------------------------

//-- I2S clock enable generation, master mode. The clock is a fraction of the
//-- LMMI bus clock, determined by the conf_ratio_w value.
always@(posedge sysclk)
  if(reset == 1'b0) begin
    clkenable <= 1'b0;
    clkcount    <= 1;
    negedge   <= 1'b0;
    toggle     <= 1'b0;
  end else begin
    if (conf_en_w ==1'b0) begin       //-- disabled
       clkenable <= 1'b0;
       clkcount    <= 1;
       negedge   <= 1'b0;
       toggle     <= 1'b0;
    end else begin                   //  -- enabled
      if (clkcount < conf_ratio_w) begin
        clkcount    <= (clkcount + 1) % 1024;
        clkenable <= 1'b0;
      end else begin
        clkcount    <= 1;
        clkenable <= 1'b1;
        negedge   <= !negedge;
      end
      toggle <= negedge;
    end
  end


//-- Process to generate word select signal, master mode
assign  lrclk = lrclkreg;
always@ (posedge sysclk) begin
  if(reset == 1'b0) begin
    lrclkreg      <= 1'b0;
    lrclkcount      <= 0;
    lrclkposedge <= 1'b0;
    lrclknegedge <= 1'b0;
  end else begin
    if (conf_en_w == 1'b0) begin
      lrclkreg      <= 1'b0;
      lrclkcount      <= 0;
      lrclkposedge <= 1'b0;
      lrclknegedge <= 1'b0;
    end else begin
      if ((clkenable == 1'b1) && (toggle == 1'b1)) begin
        if (lrclkcount < txrx) begin
          lrclkcount <= lrclkcount + 1;
        end else begin
          lrclkreg <= !lrclkreg;
          lrclkcount <= 0;
          if (lrclkreg == 1'b1) begin
            lrclknegedge <= 1'b1;
          end else begin
            lrclkposedge <= 1'b1;
          end
        end
      end else begin
        lrclkposedge <= 1'b0;
        lrclknegedge <= 1'b0;
      end
    end
  end
end

//-- Process to receive data on din, or transmit data on dout
always@(posedge sysclk) begin
  if(reset == 1'b0) begin
    memdrwr   <= 1'b0;
    sd_ctrl_r     <= IDLE;
    datainreg     <= 0;
    bclkcount     <= 0;
    txrx <= 0;
    newword    <= 1'b0;
    sendreg      <= 1'b0;
  end else begin
    if (conf_en_w == 1'b0) begin          //-- codec disabled
      memdrwr   <= 1'b0;
      sd_ctrl_r     <= IDLE;
      datainreg     <= 0;
      bclkcount     <= 0;
      txrx <= 0;
      newword    <= 1'b0;
      sendreg      <= 1'b0;
    end else begin
      case (sd_ctrl_r)
        IDLE : begin
          memdrwr <= 1'b0;
          if ((conf_res_w > 7) && (conf_res_w <= DATA_WIDTH)) begin
            txrx <= conf_res_w - 1;
          end else begin
            txrx <= 7;
          end
          if ((lrclkposedge == 1'b1 & conf_swap_w == 1'b1) ||
            (lrclknegedge == 1'b1 & conf_swap_w == 1'b0)) begin
            if (receiver_w == 1'b1) begin        //-- recevier
              sd_ctrl_r <= WAIT_CLK;
            end else begin
              memdrwr <= 1'b1;  //-- read first data if transmitter
              sd_ctrl_r   <= TRX_DATA;
            end
          end
        end
        WAIT_CLK : begin        //-- wait for first bit after WS
          bclkcount  <= 0;
          newword <= 1'b0;
          datainreg  <= 0;
          if ((clkenable == 1'b1) && (negedge == 1'b0)) begin
            sd_ctrl_r <= TRX_DATA;
          end
        end
        TRX_DATA : begin         //-- transmit/receive serial data
          memdrwr <= 1'b0;
          if ((lrclkposedge == 1'b1) || (lrclknegedge == 1'b1)) begin
            newword <= 1'b1;
          end

          //-- recevier operation
          if (receiver_w == 1'b1) begin
            if ((clkenable == 1'b1) && (negedge == 1'b1)) begin
              if ((bclkcount < txrx) && (newword == 1'b0)) begin
                bclkcount                            <= bclkcount + 1;
                datainreg[txrx - bclkcount] <= din;
              end else begin
                memdrwr                          <= 1'b1;
                datainreg[txrx - bclkcount] <= din;
                sd_ctrl_r                            <= RX_WRITE;
              end
            end
          end
          //-- transmitter operation
          if (receiver_w == 1'b0) begin
            if ((clkenable == 1'b1) && (negedge == 1'b0)) begin
              if ((bclkcount < txrx) && (newword == 1'b0)) begin
                bclkcount <= bclkcount + 1;
                sendreg  <= i2din[txrx - bclkcount];
              end else begin
                bclkcount <= bclkcount + 1;
                if (bclkcount > txrx) begin
                  sendreg <= 1'b0;
                end else begin
                  sendreg <= i2din[0];
                end
                //-- transmitter address counter
                memdrwr <= 1'b1;
                sd_ctrl_r   <= SYNC;
              end
            end
          end
        end
        RX_WRITE : begin         //-- write received word to sample buffer
          memdrwr <= 1'b0;
          sd_ctrl_r <= SYNC;
        end
        SYNC : begin            //-- synchronise with next word
          memdrwr <= 1'b0;
          bclkcount   <= 0;
          if ((lrclkposedge ==1'b1) || (ws_neg_edge_r == 1'b1)) begin
            newword <= 1'b1;
          end

          newword <= 1'b0;
          datainreg  <= 0;
          sd_ctrl_r  <= TRX_DATA;
        end
        default: begin sd_ctrl_r  <= IDLE; end
      endcase
    end
  end
end

endmodule