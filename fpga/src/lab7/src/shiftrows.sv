module shiftrows(input [127:0] sreg,
                 output [127:0] shiftedmatrix);


logic [2:0] i,j; 
logic [7:0] initmatrix[0:3][0:3];
logic [7:0] shiftedrows[0:3][0:3];

    always_comb begin
        for (i = 0; i < 4; i++) begin
            for (j = 0; j < 4; j++) begin
                initmatrix[i][j] = sreg[127 - 8*(4*j + i) : 120 - 8*(4*j + i)];;
            end
        end
    end

logic [2:0] rows, cols; 
    always_comb begin
        for (rows = 0; rows < 4; rows++) begin
            case (rows) 
                0: begin
                    shiftedrows[rows][0] = initmatrix[rows][0];
                    shiftedrows[rows][1] = initmatrix[rows][1];
                    shiftedrows[rows][2] = initmatrix[rows][2];
                    shiftedrows[rows][3] = initmatrix[rows][3];
                end
                1: begin
                    shiftedrows[rows][3] = initmatrix[rows][0];
                    shiftedrows[rows][0] = initmatrix[rows][1];
                    shiftedrows[rows][1] = initmatrix[rows][2];
                    shiftedrows[rows][2] = initmatrix[rows][3]; 
                end
                2: begin
                    shiftedrows[rows][2] = initmatrix[rows][0];
                    shiftedrows[rows][3] = initmatrix[rows][1];
                    shiftedrows[rows][0] = initmatrix[rows][2];
                    shiftedrows[rows][1] = initmatrix[rows][3]; 
                end
                3: begin
                    shiftedrows[rows][1] = initmatrix[rows][0];
                    shiftedrows[rows][2] = initmatrix[rows][1];
                    shiftedrows[rows][3] = initmatrix[rows][2];
                    shiftedrows[rows][0] = initmatrix[rows][3]; 
                end
            endcase
        end
    end
    
    always_comb begin
        for (i = 0; i < 4; i++) begin
            for (j = 0; j < 4; j++) begin
                shiftedmatrix[127 - 8*(4*j + i) : 120 - 8*(4*j + i)] = shiftedrows[i][j];
            end
        end
    end

endmodule