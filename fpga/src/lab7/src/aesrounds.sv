module aesrounds(input int_osc,
                 input reset,
                 input [127:0] plaintext,
                 input [127:0] subbytes, 
                 input [127:0] shiftedmatrix,
                 input [127:0] mixedcols, 
                 input [127:0] nextkey,
                 input complete,
                 output logic [127:0] sreg,
                 output logic [3:0] counter,
                 output logic alarm,
                 output logic done,
                 output logic sudone,
                 output logic [127:0] cyphertext);

typedef enum logic [3:0] {idle, init, bytes, rows, cols, key, finished} statetype;
statetype state, nextstate; 
logic [127:0] nextreg;


always_ff @(posedge int_osc, negedge reset) begin
	if(reset == 0) begin
		state <= idle;
	end
	else begin
		state <= nextstate;
	end
end

always_ff @(posedge int_osc, negedge reset) begin
    if (reset == 0) begin
        counter <= 4'd0;
    end
    else if (state == idle) begin
        counter <= 4'd0; 
    end
    else if (state == key) begin
        counter <= counter + 1;
    end
end

always_comb begin
case(state)
    idle: begin
        if (plaintext != 128'd0) nextstate <= init;
        else nextstate <= idle; 
    end
    init: begin
        nextstate <= bytes;
    end
    bytes: begin
        if (sudone == 0) nextstate <= bytes;
        else nextstate <= rows;
    end
    rows: begin
        if (counter < 4'd10)begin
            nextstate <= cols;
        end 
        else nextstate <= key; 
    end

    cols: begin 
        nextstate <= key;
    end
    key: begin 
    if ((complete) && counter < 4'd10)
        nextstate <= bytes;     
    else if ((complete) && counter == 4'd10)
        nextstate <= finished;  
    else nextstate <= key;   
    end
    finished: begin
        nextstate <= idle; 
    end
    default: begin 
        nextstate <= idle;
    end 

endcase
end

always_ff @(posedge int_osc, negedge reset) begin
    if (reset == 0) begin
        sreg <= 128'd0;
    end
    else sreg <= nextreg;
end

always_comb begin
    case(state)
    idle: nextreg <= 128'd0;
    init: nextreg <= plaintext ^ nextkey;
    bytes: nextreg <= subbytes;
    rows: nextreg <= shiftedmatrix;
    cols: nextreg <= mixedcols;
    key: nextreg <= nextkey;
    finished: nextreg <= 128'd0;
    default: nextreg <= sreg;
    endcase
end

// Rest of code defines specific signals used internally and externally
always_comb begin
    // Default values
    alarm <= 0;
    done <= 0;
    ciphertext <= 128'd0;
    case(state)
        idle: begin
            alarm <= 0;
            done <= 0;
        end
        init: begin
            alarm <= 0;
            done <= 0;
        end
        bytes: begin
            alarm <= 0;
            done <= 0;

        end
        rows: begin
            alarm <= (counter >= 4'd10);  
            done <= 0;
        end
        finished: begin
            alarm <= 0;
            done <= 1;
            cyphertext <= sreg;
        end
        default: begin
            alarm <= 0;
            done <= 0;
        end
    endcase
end


endmodule