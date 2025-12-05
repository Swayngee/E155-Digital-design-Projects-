// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the fsm for the keyexpansion module
// 11/03/25

module keyexpansion(input  logic int_osc,
                    input  logic load,
                    input logic add,
                    input  logic [127:0] key,
                    input logic [127:0] sreg,
                    input  logic [3:0] counter,        
                    output logic [127:0] nextkey,
                    output logic complete);
   
logic [31:0] w [0:3];       
logic [31:0] neww [0:3];    
logic [31:0] subword, tempword;            
logic [5:0] wordcount;            
logic [3:0] currentround;          
logic [1:0] bytecompute;            
logic [7:0] sboxin, sboxout;

typedef enum logic [3:0] {idle, init, waitload, sbox0, sbox1, sbox2, sbox3, capture, comp, waiter, finish} statetype;
statetype state, nextstate;

assign tempword = {w[3][23:0], w[3][31:24]};

always_comb begin
    case(bytecompute)
        2'd0: sboxin <= tempword[31:24];
        2'd1: sboxin <= tempword[23:16];  
        2'd2: sboxin <= tempword[15:8];    
        2'd3: sboxin <= tempword[7:0];  
        default: sboxin <= 8'h00;
    endcase
end

sbox_sync sbox_func(sboxin, int_osc, sboxout);

localparam logic [31:0] rcon [0:9] = '{32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000, 32'h10000000,
32'h20000000, 32'h40000000, 32'h80000000, 32'h1b000000, 32'h36000000};

// nextstate logic
always_ff @(posedge int_osc) begin
    if (load == 1)
        state <= idle;
    else
        state <= nextstate;
end

// follow pesudocode given, send through sbox after compute state
always_comb begin
nextstate <= state;
case(state)
    idle:
        if (load || add)
            nextstate <= init;          
    init: begin
        if (counter == 4'd0)
            nextstate <= finish;  
        else
            nextstate <= waitload;  
    end
    waitload: nextstate  <= sbox0;
    sbox0: nextstate <= sbox1;
    sbox1: nextstate <= sbox2;
    sbox2: nextstate <= sbox3;
    sbox3: nextstate <= capture;
    capture: nextstate <= waiter;
    waiter: nextstate <= comp;
    comp: begin  
        if (wordcount >= 8) begin
            nextstate <= finish;
        end
        else begin
            nextstate <= comp;
        end
    end
    finish:  nextstate <= idle;    
    default: nextstate <= idle;
endcase
end

always_ff @(posedge int_osc) begin
if (load == 1) begin
    wordcount <= 0;
    currentround <= 0;
    bytecompute <= 0;
    w[0] <= 32'h0;
    w[1] <= 32'h0;
    w[2] <= 32'h0;
    w[3] <= 32'h0;
    neww[0] <= 32'h0;
    neww[1] <= 32'h0;
    neww[2] <= 32'h0;
    neww[3] <= 32'h0;
    subword <= 32'h0;
end
else begin
    case(state)
    idle: begin
    if (load || add) begin
        wordcount <= 0;
        currentround <= counter;
        end
    end   
    init: begin
    if (counter == 4'd0) begin
        {neww[0], neww[1], neww[2], neww[3]} <= key;
        end
    else begin
        {w[0], w[1], w[2], w[3]} <= sreg;
        wordcount <= 4;
        bytecompute <= 0;
        end
end          
waitload: bytecompute <= 0;
    sbox0: begin
            bytecompute <= 1;
    end              
        sbox1: begin
        bytecompute <= 2;
        subword[31:24] <= sboxout;
    end            
    sbox2: begin
        bytecompute <= 3;
        subword[23:16] <= sboxout;
        end                 
    sbox3: begin
        bytecompute <= 0;
        subword[15:8] <= sboxout;
    end     
        capture: begin
        subword[7:0] <= sboxout;
    end       
    comp: begin
        case(wordcount)
            4: neww[0] <= w[0] ^ subword ^ rcon[currentround - 1];  
            5: neww[1] <= w[1] ^ neww[0];  
            6: neww[2] <= w[2] ^ neww[1];  
            7: neww[3] <= w[3] ^ neww[2];  
        endcase
            wordcount <= wordcount + 1;
    end 
    finish: begin
        wordcount <= 0;
    end
endcase
end
end
assign nextkey = {neww[0], neww[1], neww[2], neww[3]};
assign complete = (state == finish);

endmodule