// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the combinational logic for the 7-segment display. Each hexadecimal will be displayed 
// as a result of the output segment seg[6:0]
// 9/8/25

module lab3_dg_seg(input logic [7:0] controller,
                   output logic [6:0] seg);
always_comb begin
case (controller)
            8'b11011110: seg = 7'b1000000;
            8'b11100111: seg = 7'b1001111;
            8'b11010111: seg = 7'b0100100;
            8'b10110111: seg = 7'b0110000;
            8'b11101011: seg = 7'b0011001;
            8'b11011011: seg = 7'b0010010;
            8'b10111011: seg = 7'b0000010;
            8'b11101101: seg = 7'b1111000;
            8'b11011101: seg = 7'b0000000;
            8'b10111101: seg = 7'b0011000;
            8'b11101110: seg = 7'b0001000;
            8'b10111110: seg = 7'b0000011;
            8'b01110111: seg = 7'b1000110;
            8'b01111011: seg = 7'b0100001;
            8'b01111101: seg = 7'b0000110;
            8'b01111110: seg = 7'b0001110;
            default:     seg = 7'b0000000;
        endcase
    end 
endmodule