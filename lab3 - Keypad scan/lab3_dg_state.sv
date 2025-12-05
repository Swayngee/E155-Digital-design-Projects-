// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the state machine along with eahc output
// 9/20/25

module lab3_dg_state(input logic int_osc,
            input logic reset,
            input logic [3:0] sync,
            output logic [3:0] cols,
            output logic [7:0] keypress,
            output logic alarm);

typedef enum logic [3:0] {idle, waiter, check, drive, last} statetype;
//logic [3:0] holdcols;
statetype state, nextstate;
logic [3:0] v;
//logic [3:0] srows;
//logic [7:0] prekey;
logic [19:0] counter1;
logic [7:0] keylatch; 


logic counter1_enable, counter_done, v_enable, pressed, all_on;

// Assigned vars
assign pressed = (sync != 4'b1111);
assign keypress = {cols, sync};

// Counter
always_ff @(posedge int_osc, negedge reset) begin
	if (reset == 0) begin
		counter1 <= 0;
		counter_done <= 0;
	end
	else if (counter1_enable) begin
		if (counter1 >= 20'd50000)begin
			counter1 <= 0;
			counter_done <= 1;
		end
		else begin
			counter1 <= counter1 + 1;
			counter_done <= 0;
		end
	end
	else begin
		counter1 <= 0;
		counter_done <= 0;
	end
end



// State ff
always_ff @(posedge int_osc, negedge reset) begin
	if(reset == 0) begin
		state <= idle;
	end
	else begin
		state <= nextstate;
	end
end

// Next state Logic
always_comb begin
nextstate = state;
case(state)
	idle: begin 
		if (pressed) nextstate <= waiter;
		else nextstate <= idle;
		end
	waiter: begin
		if (counter_done) nextstate <= check;
		else nextstate <= waiter;
		end
	check: begin
		if (pressed) begin 
			nextstate <= drive;
		end
		else nextstate <= idle;
		end
	drive: begin
		nextstate <= last;
	end
	last: begin
		if (!pressed) 
    		nextstate <= waiter;
		else if (sync != keylatch[3:0])  
    		nextstate <= waiter;  
		else
    		nextstate <= last;
	end

	default: nextstate <= idle;
endcase
end

always_ff @(posedge int_osc, negedge reset) begin
    if (reset == 0) begin
        keylatch <= 8'b0;
    end
    else if (state == check && pressed) begin
        keylatch <= keypress;
		end
	else if (state == idle) begin
		keylatch <= 8'b0; 
		end
end




// Output Logic
always_comb begin
case(state)
	idle: begin
		v_enable <= 1;
		alarm <= 0;
		counter1_enable <= 0;
		all_on <= 0;
	end
	waiter: begin
		v_enable <= 0;
		alarm <= 0;
		counter1_enable <= 1;
		all_on <= 0;
	end
	check: begin
		v_enable <= 0;
		alarm <= 0;
		counter1_enable <= 0;
		all_on <= 0;
	end
	drive: begin
		v_enable <= 0;
		alarm <= 1;
		counter1_enable <= 0;
		all_on <= 0;
	end
	last: begin
		v_enable <= 0;
		alarm <= 0;
		counter1_enable <= 0;
		all_on <= 1;
	end
	default: begin
		v_enable <= 1;
		alarm <= 0;
		counter1_enable <= 0;
		all_on <= 0;
	end
endcase
end



// cols output logic
always_ff @(posedge int_osc, negedge reset) begin
	if (reset == 0) begin
		v <= 0;
	end
	else if(v_enable) begin
		v <= v + 4'b1;
	end
	else v <= v;
	end

always_comb begin
	if ( all_on ) begin
	cols = 4'b0000;
	end
	else begin
	case(v)
		0: cols = 4'b1110;
		1: cols = 4'b1110;
		2: cols = 4'b1110;
		3: cols = 4'b1110;
		4: cols = 4'b1101;
		5: cols = 4'b1101;
		6: cols = 4'b1101;
		7: cols = 4'b1101;
		8: cols = 4'b1011;
		9: cols = 4'b1011;
		10: cols = 4'b1011;
		11: cols = 4'b1011;
		12: cols = 4'b0111;
		13: cols = 4'b0111;
		14: cols = 4'b0111;
		15: cols = 4'b0111;
	endcase
	end
end
endmodule

