EASY (1–5)

Q1 — Combinational Logic
Write an always_comb block for:

y = (a | b) & ~c;

always_comb begin 

y = (a | b) & ~c;

end 


Q2 — Sequential Logic / D Flip-Flop
Write an always_ff block for a D flip-flop with synchronous reset.

always_ff @(posedge reset) begin 
if (reset) q <=0;
else q <=d; 

end


Q3 — Blocking vs Non-blocking
Explain in 1–2 sentences the difference between = and <= in sequential logic.

= is puirely combinational logic. Exceutes instructions sequentially. 
<= means that all instructions occur at the end of the clock edge. 

Q4 — 4-bit Shift Register
Serial-in, parallel-out, synchronous reset. Describe the code in always_ff.

always_ff @(posedge clk) begin 
    if (reset) parallel-out = 4'd0;
    else begin 
        parrallel-out <= serialin; 
    
    end
end 

Q5 — FSM Typedef
Define a 3-state FSM (IDLE, LOAD, EXECUTE) using typedef enum logic.

typedef enum logic [1:0]{IDLE, LOAD, EXECUTE} statetype; 

MEDIUM (6–10)

Q6 — 2-Flip-Flop Synchronizer
Write a 2-FF synchronizer for single-bit async input async_in and output sync_out.

logic inside; 
always_ff @(posedge clk or negedge reset) begin 
    if (reset) parallel-out = 4'd0;
    else begin 
        inside <= async_in;
        sync_out <= inside; 
    
    end
end 


Q7 — FIFO Full/Empty Logic (synchronous)
Given 8-depth FIFO, 3-bit wr_ptr and rd_ptr. Write expressions for fifo_full and fifo_empty.

fifo_empty = (wr_ptr == rd_ptr);
fifo_full = ((wr_ptr +1 )== rd_ptr);

Q8 — CDC Problem Identification
Why is this unsafe?

always_ff @(posedge clkA)
  dataA <= in_data;

always_ff @(posedge clkB)
  dataB <= dataA; // crosses domains

This is unsafe due to the dataA being metastable between clocks, especially when its more than one bit.  


Q9 — Priority Arbiter
Write RTL for a 4-request priority arbiter. Inputs: req[3:0], Output: grant[3:0] (one-hot).

always_comb begin 
grant = 4'd0;
if (req[3]) grant = 4'b1000; 
else if (req[2]) grant = 4'b0100; 
else if (req[1]) grant = 4'b0010; 
else if (req[30]) grant = 4'b0001; 
end 

Q10 — Mealy vs Moore
Explain the difference and name one advantage of each.

Moore machines the outputs depend only on current state. Mealy machines the outputs depend on state & current inputs 

HARD (11–15)

Q11 — Asynchronous FIFO Empty Detection
Given reader binary pointer rd_ptr_bin and synchronized writer pointer wr_ptr_bin_sync (from Gray code), write the expression for fifo_empty.

fifo_empty = (rd_ptr_bin == wr_ptr_bin_sync);

Q12 — Toggle Pulse Synchronizer
Write RTL that generates a 1-cycle pulse in clkB domain when a toggle tog changes in clkA domain.

always_ff @(posedge clkA) begin 
if (en) tog <= ~tog; 
end 
logic toggle_1, toggle_2;
always_ff @(posedge clkB) begin 
    toggle_1 <= tog;
    toggle_2 <= toggle_1; 
end 
assign output = toggle_1 ^ toggle_2; 


Q13 — 512:1 Multiplexer
Write a parameterized SystemVerilog module for a 512:1 mux (data width = 1 bit).




Q14 — Pattern Detector (1101)
Design a block with inputs clk, d, output match to detect pattern 1101 in a serial input stream.

always_ff @(posedge clk) begin 
    if (d == 4'b1101)
        output <= d; 
    else 
        output <= 4'd0; 
end


Q15 — 7-bit Population Count
Given input logic [6:0] a, write combinational logic to count number of 1’s and output as logic [2:0] count.


always_comb begin 
    count = 3'd0; 
    if (a[7] == 1'd1;) count = count + 1; 
    if (a[6] == 1'd1;) count = count + 1'd1; 
    if (a[5] == 1'd1;) count = count + 1'd1; 
    if (a[4] == 1'd1;) count = count + 1'd1; 
    if (a[3] == 1'd1;) count = count + 1'd1; 
    if (a[2] == 1'd1;) count = count + 1'd1; 
    if (a[1] == 1'd1;) count = count + 1'd1;
    if (a[0] == 1'd1;) count = count + 1'd1;

end 