module subbytes(input int_osc,
                input reset, 
                input [127:0] sreg,
                input [7:0] subox,
                output [127:0] subbytes,
                output logic [7:0] boxreg
                output logic sudone);
    
typedef enum logic [2:0] {idle, init, sub, ouput, subdone} statetype;
statetype state, nextstate; 
logic [3:0] counter; 
logic [7:0] subreg;

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
    else if (state == output) begin
        counter <= counter + 1;
    end
end

always_ff @(posedge int_osc, negedge reset) begin
    if (reset == 0) begin
        boxreg <= 128'd0;
    end
    else boxreg <= subreg;
end
    always_comb begin
        case(state)
        idle: begin
            if (sreg != 128'd0) begin
                nextstate <= init;
            end
            else nextstate <= idle; 
        end
        init: begin 
            nextstate <= sub;
        end
        sub: begin 
            nextstate <= output;
        end
        output: begin 
            if (counter < 16) nextstate <= sub;
            else nextstate <= subdone;
        end
        subdone: nextstate <= idle; 
        default: nextstate <= state;

        endcase
    end
always_comb begin
    case(state)
    idle: subreg <= 128'd0;
    init: subreg <= 128'd0;
    sub: subreg <= sreg[127 - 8*counter : 120 - 8*counter];
    output: subreg <= subox;
    subdone: begin 
        subreg <= 128'd0;
        subbytes <= boxreg;
    end
    default: subreg <= boxreg;
    endcase
end
always_comb begin 
    sudone <= 0;
case(state)
    idle: sudone <= 0;
    init: sudone <= 0;
    sub: sudone <= 0;
    output: sudone <= 0;
    subdone: sudone <= 1;
    default: subreg <= boxreg;
endcase

end

endmodule