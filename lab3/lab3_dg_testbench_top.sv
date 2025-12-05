// Drake Gonzales
// drgonzales@g.hmc.edu
// Testbench for the top module. Hosts three test, each with different input switches
// 9/20/25
`timescale 1ns/1ps
module lab3_dg_testbench_top();
logic reset;
logic [3:0] rows;
logic [3:0] cols;
logic [6:0] seg;
logic disp1, disp2;
logic [31:0]  errors;

// expected values
logic [6:0] segexpected1, segexpected2;

lab3_dg_top u_top(reset, rows, cols, seg, disp1, disp2);

//always begin
//int_osc = 1; #5; 
//int_osc = 0; #5;
//end
initial begin
errors = 0; 
reset  = 1; #22; 
reset  = 0;
    // test1


    rows = 4'b1101;
    repeat (20) @(posedge u_top.int_osc);
	
    case({rows, cols})
        8'b1101_1110: begin 
			segexpected1 = 7'b1000000; 
			segexpected2 = 7'b1000000; 
			end
        default: begin 
			segexpected1 = 7'b1111111;
			segexpected2 = 7'b1111111; 
			end
    endcase


	// check left display
    repeat (20) @(posedge u_top.int_osc);
    if (disp1 && seg != segexpected1) begin
        errors= errors+1;
		$display("Test11 displays failed");
    end

    // check right display
    repeat (20) @(posedge u_top.int_osc);;
    if (disp2 && seg != segexpected2) begin
        errors =errors +1;
        $display("Test12 displays failed");
    end

    // test2
    rows= 4'b1011;
    repeat (20) @(posedge u_top.int_osc);
	
    case({rows, cols})
        8'b10111011: begin 
			segexpected1 = 7'b0000010; 
			segexpected2 = 7'b1000000; 
			end
        default: begin 
			segexpected1 = 7'b1111111;
			segexpected2 = 7'b1111111; 
			end
    endcase

    repeat (20) @(posedge u_top.int_osc);
    // check left display
    if (disp1 && seg != segexpected1) begin
        errors = errors +1;
		$display("Test21 displays failed");
    end
    // check right display
    repeat (20) @(posedge u_top.int_osc);
    if (disp2 && seg != segexpected2) begin
        errors= errors +1;
        $display("Test22 displays failed");
    end

    // test3
    rows = 4'b0111;
   repeat (20) @(posedge u_top.int_osc);
	
    case({rows, cols})
        8'b01111110: begin 
			segexpected1 = 7'b0001110; 
			segexpected2 = 7'b0000010; 
			end
        default: begin 
			segexpected1 = 7'b1111111;
			segexpected2 = 7'b1111111; 
			end
    endcase
    repeat (20) @(posedge u_top.int_osc);
	
    // check left display
    if (disp1 && seg != segexpected1) begin
        errors= errors +1;

		$display("Test31 displays failed");
    end
    // check right display
    repeat (20) @(posedge u_top.int_osc);
    if (disp2 && seg != segexpected2) begin
        errors = errors+1;
        $display("Test32 displays failed");
    end


    $display("All tests done. Total errors = %0d", errors);
    $finish;
end
endmodule
