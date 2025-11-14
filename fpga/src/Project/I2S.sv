module lscc_i2s_codec #(
    parameter int DATA_WIDTH       = 16,
    parameter bit TRANSCEIVER_MODE = 0
)(
    input  logic                     reset,        // active-low reset (0 = reset)
    input  logic                     sysclk,       // LMMI clock
    input  logic        [5 : 0]      sampleres,    // sample resolution
    input  logic        [9 : 0]      clkdiv,       // clock divider ratio
    input  logic                     sampleorder,  // left/right sample order
    input  logic                     enabler,      // transmitter/receiver enable
    input  logic                     din,          // I2S serial data input
    input  logic        [31 : 0]     i2din,        // audio data // Input from ADC
    output logic        [31 : 0]     i2dout,       // audio data // Output to ADC
    output logic                     buffer,       // sample buffer read/write (pulse)
    output logic                     dout,         // I2S serial data output
    output logic                     bclk,         // I2S bit clock output
    output logic                     lrclk         // I2S word select output
);

    // -----------------------------------------------------------------------------
    // Local Parameters (FSM states)
    // -----------------------------------------------------------------------------
    localparam int IDLE     = 0;
    localparam int WAIT_CLK = 1;
    localparam int TRX_DATA = 2;
    localparam int RX_WRITE = 3;
    localparam int SYNC     = 4;

    // -----------------------------------------------------------------------------
    // Internal Signals
    // -----------------------------------------------------------------------------
    logic                      clkenable;
    logic        [9 : 0]       clkcount;
    logic        [4 : 0]       sd_ctrl_r;
    logic        [4 : 0]       bclkcount;
    logic        [4 : 0]       txrx;                // number of bits - 1 (index)
    logic                      toggle;              // used as bclk
    logic                      bclk_edge;           // active when bclk toggles
    logic                      lrclkreg;
    logic                      lrclk_prev;
    logic                      lrclkposedge;
    logic                      lrclknegedge;
    logic [DATA_WIDTH-1 : 0]   datainreg;
    logic                      newword;
    logic                      memdrwr;
    logic        [4 : 0]       lrclkcount;
    logic                      sendreg;

    // “Wire” equivalents:
    logic        [5 : 0]       conf_res_w;
    logic        [9 : 0]       conf_ratio_w;
    logic                      conf_swap_w;
    logic                      conf_en_w;
    logic                      receiver_w;

    // ----------------------------------------------------------------------------- 
    // Continuous assignments
    // -----------------------------------------------------------------------------
    assign dout        = sendreg;
    assign conf_res_w  = sampleres;
    assign conf_ratio_w = clkdiv;
    assign conf_swap_w = sampleorder;
    assign conf_en_w   = enabler;

    assign receiver_w  = (TRANSCEIVER_MODE == 1) ? 1'b1 : 1'b0;

    assign bclk        = toggle;
    assign buffer      = memdrwr;
    assign i2dout      = {{(32-DATA_WIDTH){1'b0}}, datainreg};

    // -----------------------------------------------------------------------------
    // I2S bit-clock generation (master). 'reset' is active-low (0 = reset).
    // -----------------------------------------------------------------------------
    always_ff @(posedge sysclk) begin
      if (reset == 1'b0) begin
        clkenable   <= 1'b0;
        clkcount    <= 10'd1;
        bclk_edge   <= 1'b0;
        toggle      <= 1'b0;
      end else begin
        if (conf_en_w == 1'b0) begin
          clkenable   <= 1'b0;
          clkcount    <= 10'd1;
          bclk_edge   <= 1'b0;
          toggle      <= 1'b0;
        end else begin
          // increment clock divider counter until ratio reached
          if (clkcount < conf_ratio_w) begin
            clkcount  <= clkcount + 10'd1;
            clkenable <= 1'b0;
            bclk_edge <= 1'b0;
          end else begin
            clkcount  <= 10'd1;
            clkenable <= 1'b1;
            bclk_edge <= 1'b1;          // one-cycle pulse when bclk toggles
            toggle    <= ~toggle;
          end
        end
      end
    end

    // -----------------------------------------------------------------------------
    // LRCLK (word select) generation: flip after txrx+1 bclk cycles.
    // We'll detect edges by comparing current and previous lrclkreg.
    // -----------------------------------------------------------------------------
    // lrclk toggled synchronized to bclk edges (use bclk_edge)
    always_ff @(posedge sysclk) begin
      if (reset == 1'b0) begin
        lrclkreg     <= 1'b0;
        lrclk_prev   <= 1'b0;
        lrclkcount   <= 5'd0;
        lrclkposedge <= 1'b0;
        lrclknegedge <= 1'b0;
      end else begin
        if (conf_en_w == 1'b0) begin
          lrclkreg     <= 1'b0;
          lrclk_prev   <= 1'b0;
          lrclkcount   <= 5'd0;
          lrclkposedge <= 1'b0;
          lrclknegedge <= 1'b0;
        end else begin
          lrclkposedge <= 1'b0;
          lrclknegedge <= 1'b0;

          if (clkenable && bclk_edge) begin
            if (lrclkcount < txrx) begin
              lrclkcount <= lrclkcount + 1;
            end else begin
              lrclkreg   <= ~lrclkreg;
              lrclkcount <= 5'd0;
              // We'll detect edges next cycle via lrclk_prev
            end
          end
          // update edge detectors
          lrclk_prev <= lrclkreg;
          if ((lrclkreg == 1'b1) && (lrclk_prev == 1'b0))
            lrclkposedge <= 1'b1;
          else if ((lrclkreg == 1'b0) && (lrclk_prev == 1'b1))
            lrclknegedge <= 1'b1;
        end
      end
    end

    // expose lrclk
    assign lrclk = lrclkreg;

    // -----------------------------------------------------------------------------
    // Main FSM: receive (din) or transmit (dout)
    // -----------------------------------------------------------------------------
    always_ff @(posedge sysclk) begin
      if (reset == 1'b0) begin
        memdrwr    <= 1'b0;
        sd_ctrl_r  <= IDLE;
        datainreg  <= '0;
        bclkcount  <= 5'd0;
        txrx       <= 5'd0;
        newword    <= 1'b0;
        sendreg    <= 1'b0;
      end else begin
        if (conf_en_w == 1'b0) begin
          memdrwr    <= 1'b0;
          sd_ctrl_r  <= IDLE;
          datainreg  <= '0;
          bclkcount  <= 5'd0;
          txrx       <= 5'd0;
          newword    <= 1'b0;
          sendreg    <= 1'b0;
        end else begin
          // default values each cycle (unless changed in case)
          memdrwr <= 1'b0;
          case (sd_ctrl_r)
            IDLE: begin
              newword <= 1'b0;
              bclkcount <= 5'd0;
              // decide txrx (bit index) based on sample resolution
              if ((conf_res_w > 6) && (conf_res_w <= DATA_WIDTH)) begin
                // conf_res_w is sample size in bits; txrx is index (bits-1)
                txrx <= conf_res_w - 1;
              end else begin
                txrx <= 5'd7; // default 8-bit frames
              end

              // Wait for the appropriate LRCLK edge to start a word:
              // sampleorder (conf_swap_w) controls whether we start on lrclk negedge or posedge.
              // If sampleorder==0: start on lrclknegedge; else start on lrclkposedge.
              if ((lrclknegedge && (conf_swap_w == 1'b0)) ||
                  (lrclkposedge && (conf_swap_w == 1'b1))) begin
                if (receiver_w) begin
                  // receiver waits for first bclk edge (Falling or rising depending on I2S)
                  sd_ctrl_r <= WAIT_CLK;
                end else begin
                  // transmitter: load first data from buffer (indicated by memdrwr pulse)
                  memdrwr <= 1'b1;
                  sd_ctrl_r <= TRX_DATA;
                  bclkcount <= 5'd0;
                end
              end
            end

            WAIT_CLK: begin
              // Wait for first valid bclk edge before sampling/transmitting bits
              newword <= 1'b0;
              datainreg <= '0;
              bclkcount <= 5'd0;
              if (clkenable && bclk_edge) begin
                // move into data transfer on first bclk edge
                sd_ctrl_r <= TRX_DATA;
              end
            end

            TRX_DATA: begin
              // if lrclk toggles in the middle of data, we consider new word
              if (lrclkposedge || lrclknegedge)
                newword <= 1'b1;

              // Receiver operation: sample din on bclk edge (I2S samples on second clock edge)
              if (receiver_w) begin
                if (clkenable && bclk_edge) begin
                  if (bclkcount < txrx && !newword) begin
                    // store bit; we use bit index = txrx - bclkcount
                    datainreg[txrx - bclkcount] <= din;
                    bclkcount <= bclkcount + 1;
                  end else begin
                    // last bit received - write to buffer
                    datainreg[txrx - bclkcount] <= din;
                    memdrwr <= 1'b1;
                    sd_ctrl_r <= RX_WRITE;
                  end
                end
              end else begin
                // Transmitter operation: place bits on dout on bclk edge
                if (clkenable && bclk_edge) begin
                  if (bclkcount < txrx && !newword) begin
                    // output bit indexed from i2din
                    sendreg <= i2din[txrx - bclkcount];
                    bclkcount <= bclkcount + 1;
                  end else begin
                    // when finished frame: still output last bit, then request new word
                    if (bclkcount > txrx) begin
                      sendreg <= 1'b0;
                    end else begin
                      // in case of off-by-one, ensure we output LSB
                      sendreg <= i2din[0];
                    end
                    bclkcount <= bclkcount + 1;
                    memdrwr <= 1'b1;   // request next sample from buffer
                    sd_ctrl_r <= SYNC;
                  end
                end
              end
            end

            RX_WRITE: begin
              // pulse buffer (memdrwr already asserted in TRX_DATA)
              memdrwr <= 1'b0;
              sd_ctrl_r <= SYNC;
            end

            SYNC: begin
              // wait for lrclk edge to synchronise to next word
              memdrwr <= 1'b0;
              bclkcount <= 5'd0;
              if (lrclkposedge || lrclknegedge) begin
                // go to TRX_DATA for next frame
                newword <= 1'b0;
                datainreg <= '0;
                sd_ctrl_r <= TRX_DATA;
              end
            end

            default: sd_ctrl_r <= IDLE;
          endcase
        end
      end
    end

endmodule
