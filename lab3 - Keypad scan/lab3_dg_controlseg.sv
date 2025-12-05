// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the combinational logic for the 7-segment display. Each hexadecimal will be displayed 
// 9/20/25

module lab3_dg_controlseg(input  logic  int_osc,
                            input logic reset,
                            input logic enabler,   
                            input logic alarm,     
                            input logic [7:0] keypress,  
                            output logic disp1,
                            output logic disp2,
                            output logic [7:0] controller);

logic [7:0] current;
logic [7:0] past;

always_ff @(posedge int_osc, negedge reset) begin
    if (reset == 0) begin
        current <= 8'd0;
        past <= 8'd0;
    end 
    else if (alarm == 1'b1) begin
        past <= current;
        current <= keypress;
    end
end

always_comb begin
    disp1= 1'b0;
    disp2 = 1'b0;
    controller = 8'd0;
    if (enabler == 1'b1) begin
        disp1 = 1'b1;    
		disp2 = 1'b0;
        controller = past;   
    end else begin

		disp1 = 1'b0;
        disp2  = 1'b1;      
        controller = current;
        end
    end

endmodule