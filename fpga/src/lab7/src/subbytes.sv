// Drake Gonzales
// drgonzales@g.hmc.edu
// This Module holds the subbytes module
// 11/03/25

module subbytes(input logic int_osc,
				input logic [127:0] sreg,   
				input byteenable,
                output logic [127:0] subbytes);
    // calculate subBytes
	
    logic [7:0] s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15;
	logic [127:0] allow; 
	
assign allow = byteenable ? sreg: 128'b0; 

    sbox_sync sbox_sync0(allow[127:120], int_osc, s0);
    sbox_sync sbox_sync1(allow[119:112], int_osc, s1);
    sbox_sync sbox_sync2(allow[111:104], int_osc, s2);
    sbox_sync sbox_sync3(allow[103:96], int_osc, s3);
    sbox_sync sbox_sync4(allow[95:88], int_osc, s4);
    sbox_sync sbox_sync5(allow[87:80], int_osc, s5);
    sbox_sync sbox_sync6(allow[79:72], int_osc, s6);
    sbox_sync sbox_sync7(allow[71:64], int_osc, s7);
    sbox_sync sbox_sync8(allow[63:56], int_osc, s8);
    sbox_sync sbox_sync9(allow[55:48], int_osc, s9);
    sbox_sync sbox_sync10(allow[47:40], int_osc, s10);
    sbox_sync sbox_sync11(allow[39:32], int_osc, s11);
    sbox_sync sbox_sync12(allow[31:24], int_osc, s12);
    sbox_sync sbox_sync13(allow[23:16], int_osc, s13);
    sbox_sync sbox_sync14(allow[15:8], int_osc, s14);
    sbox_sync sbox_sync15(allow[7:0], int_osc, s15);

    assign subbytes = {s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15};

endmodule
