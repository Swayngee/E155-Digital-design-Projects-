// Drake Gonzales
// drgonzales@g.hmc.edu
// This module was made for the purpose of testing our state machine by throwing in input rows
// 9/20/25

module lab3_dg_testbench_state();
logic int_osc, reset;
logic [3:0] rows;
logic [3:0] cols;
logic [3:0] sync;
logic [3:0] rowpress;
logic alarm;
logic [7:0] keypress;
logic [3:0] exp;
logic [31:0] vectornum, errors;
integer a;

lab3_dg_state u_state(int_osc, reset, sync, cols, keypress, alarm);

always
begin
int_osc = 0;
int_osc=1; #5; 
int_osc=0; #5;
end
initial
begin 
reset=1; #22; 
reset=0;
errors = 0;
rows = 4'b1111;
sync = 4'b1111; 


for (a = 0; a < 4; a++) begin
    exp  = ~(1 << a);  
    sync = exp;       
    repeat (20) @(posedge int_osc);

    if (sync !== keypress[3:0]) begin
        $display("expected row %b, got %b", rows, keypress[3:0]);
         errors= errors+1;
     end else begin
        $display("tests completed with %d errors", errors);
    end
         repeat (4) @(posedge int_osc);
        end
    $stop;
	

	
end

endmodule
