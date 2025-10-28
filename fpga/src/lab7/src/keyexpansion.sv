module keyexpansion(input  logic int_osc, 
                     input reset, 
                     input load,
                     input  logic [127:0] key,
                     input  logic [3:0]   counter,
                     output logic [127:0] nextkey,
                     output logic complete);
    
logic [31:0] w [0:43];
logic [31:0] rot, sub, rcon;
logic [5:0] count;
typedef enum logic [1:0] {idle, init, create, finish} statetype;
statetype state, nextstate;

// Code block is used to solve for subword and rotword for keyexpansion psuedocode
sbox sbox0(rot[31:24], sub[31:24]);
sbox sbox1(rot[23:16], sub[23:16]);
sbox sbox2(rot[15:8],  sub[15:8]);
sbox sbox3(rot[7:0],   sub[7:0]);


assign rot = {w[count-1][23:0], w[count-1][31:24]};

rcon= '{32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000, 32'h10000000, 
32'h20000000, 32'h40000000, 32'h80000000, 32'h1b000000, 32'h36000000};
    
// Nextstate logic
always_ff @(posedge int_osc, negedge reset)
    if (reset == 0) begin
        state <= idle;
        count <= 0;
    end 
    else state <= nextstate;
    
// Nextstate logic
always_comb begin
    case(state)
        idle: 
            if (load)
                nextstate = init;
            else nextstate = idle;
        init: 
            nextstate = create;
        create:  
            if (count > 43)
                nextstate = finish;
            else nextstate = create;
        finish: 
            nextstate = idle;

        default: nextstate = state;
    endcase
 end

 // Pos edge of the clock solve for w   
always_ff @(posedge int_osc, negedge reset) begin
    if (reset == 0) begin
        count <= 0;
    end
    else begin
    case(state)
        idle: if (load) count <= 0;
        init: begin
            {w[3], w[2], w[1], w[0]} <= key;
            count <= 4;
        end
        create: begin
            if (count % 4 == 0) // nk = 4 used 4 to use less memory
                w[count] <= w[count-4] ^ sub ^ rcon[count/4]; 
            else
                w[count] <= w[count-4] ^ w[count-1]; 
            count <= count + 1;
        end
       endcase
    end
end

// set output signal complete
always_comb begin 
    complete = (state == finish);
end 
    
assign nextkey = {w[counter*4+3], w[counter*4+2], w[counter*4+1], w[counter*4]};

endmodule