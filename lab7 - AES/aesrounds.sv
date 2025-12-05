// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the fsm for the AES rounds
// 11/03/25

module aesrounds(input logic int_osc,
				 input logic load, 
                 input logic [127:0] plaintext,
                 input logic [127:0] subbytes, 
                 input logic [127:0] shiftedmatrix,
                 input logic [127:0] mixedcols, 
                 input logic [127:0] nextkey,
                 input logic complete,
                 input logic rowsdone, 
                 input logic coldone, 
                 output logic byteenable, 
                 output logic rowenable,
                 output logic colenable, 
                 output logic [127:0] sreg,
                 output logic [3:0] counter,
                 output logic alarm,
                 output logic done,
                 output logic add,
                 output logic [127:0] cyphertext);

typedef enum logic [4:0] {idle, init, bytes, rows, cols, addkey, buffer, buffer2, finished} statetype;
statetype state, nextstate; 
logic [127:0] nextreg, colbuf, orgintext;
always_ff @(posedge int_osc) begin
    if(load == 1 ) begin
        state <= idle;
    end
    else begin
        state <= nextstate;
    end
end

always_ff @(posedge int_osc) begin
    if (load == 1) begin
        counter <= 4'd0;
    end
    else if (state == idle) begin
        counter <= 4'd0; 
    end
    else if (state == buffer) begin
        counter <= counter + 1;
    end
end

always_comb begin
nextreg <= sreg; 
nextstate <= state; 
case(state)
    idle: begin
        nextreg <= 128'd0;
        if (plaintext != 128'd0 && !load) nextstate <= init;
        else nextstate <= idle; 
    end
    
    init: begin
        if (complete) begin
        nextreg <= plaintext ^ nextkey;
        nextstate <= bytes;
        end
        else nextstate <= init; 
    end
    bytes: begin
        nextstate <= rows;
    end
    rows: begin
        nextreg <= subbytes;
        if (!rowsdone) begin 
            nextstate <= rows; 
        end 
        else if (counter < 4'd10)begin
            nextstate <= cols;
        end 
        else nextstate <= addkey; 
    end
    cols: begin     
        nextreg <= shiftedmatrix;
        if (!coldone) begin
            nextstate <= cols; 
        end
        else nextstate <= buffer;
    end 
    buffer: begin 
        nextreg <= mixedcols;
        nextstate <= buffer2; 
    end
		
	buffer2: begin 
	nextreg <= nextkey;
	if (!complete)
		nextstate <= buffer2;
	else nextstate <= addkey; 
	end 
	
    addkey: begin 
    nextreg <= nextreg ^ colbuf;
    if (counter < 4'd10)
        nextstate <= bytes;     
    else if (counter == 4'd10)
        nextstate <= finished;         
    end
    finished: begin
        nextreg <= sreg;
		nextstate <= finished; 
    end
    default: begin 
        nextreg <= 128'd0;
        nextstate <= idle;
    end 
endcase
end

always_ff @(posedge int_osc) begin 
	if (load == 1) begin 
		orgintext <= 128'd0; 
		colbuf <= 128'd0; 
		end 
		else begin 
			if (state == init && complete) 
			orgintext <= plaintext; 
			if (state == buffer) 
				colbuf <= mixedcols; 
				end 
			end

always_ff @(posedge int_osc) begin
    if (load == 1) begin
        sreg <= 128'd0; 
    end
    else sreg <= nextreg;
end

// Rest of code defines specific signals used internally and externally
always_comb begin
    // Default values
    alarm <= 0;
    done <= 0;
    add <= 0; 
    byteenable <=0;
    rowenable <= 0; 
    colenable <= 0; 
    cyphertext <= 128'd0;
    case(state)
        idle: begin
            byteenable <=0;
            rowenable <= 0; 
            colenable <= 0;
            add <= 1; 
            alarm <= 0;
            done <= 0;
            cyphertext <= sreg;
        end
        init: begin
            byteenable <=0;
            rowenable <= 0; 
            colenable <= 0;
            add <= 0; 
            alarm <= 0;
            done <= 0;
            cyphertext <= 128'd0;
        end
        bytes: begin
            byteenable <=1; 
            rowenable <= 0; 
            colenable <= 0;
            add <= 0; 
            alarm <= 0;
            done <= 0;
            cyphertext <= 128'd0;

        end
        rows: begin
            byteenable <=0;
            rowenable <= 1; 
            colenable <= 0;
            add <= 0;
			if (counter == 4'd9) 
				alarm <= 1;
			else alarm <= 0; 
            done <= 0;
            cyphertext <= 128'd0;
        end
        cols: begin
            byteenable <=0;
            rowenable <= 0; 
            colenable <= 1;
            add <= 0; 
			if (counter == 4'd9) 
				alarm <= 1;
			else alarm <= 0;
            done <= 0;
            cyphertext <= 128'd0;           
        end     
        buffer: begin 
            byteenable <= 0;
            rowenable <= 0; 
            colenable <= 0;
            add <= 0; 
			if (counter == 4'd9) 
				alarm <= 1;
			else alarm <= 0;
            done <= 0;
            cyphertext <= 128'd0;           
        end 
        buffer2: begin 
            byteenable <= 0;
            rowenable <= 0; 
            colenable <= 0;
            add <= 1; 
            alarm <= 0;
            done <= 0;
            cyphertext <= 128'd0;           
        end 
        addkey: begin 
            byteenable <=0;
            rowenable <= 0; 
            colenable <= 0;
            alarm <= 0;
            done <= 0;
            cyphertext <= 128'd0;
            add <= 0; 
        end
        finished: begin
            byteenable <=0;
            rowenable <= 0; 
            colenable <= 0;
            add <= 0; 
            alarm <= 0;
            done <= 1;
            cyphertext <= sreg;
        end
        default: begin
            byteenable <=0;
            rowenable <= 0; 
            colenable <= 0;
            add <= 0; 
            alarm <= 0;
            done <= 0;
            cyphertext <= 128'd0;
        end
    endcase
end


endmodule
