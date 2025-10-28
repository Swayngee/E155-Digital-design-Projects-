/////////////////////////////////////////////
// mixcolumns
//   Even funkier action on columns
//   Section 5.1.3, Figure 9
//   Same operation performed on each of four columns
/////////////////////////////////////////////

module mixcolumns(input [127:0] sreg,
                  input alarm,
                  output logic [127:0] mixedcols);

  mixcolumn mc0(sreg[127:96], alarm, mixedcols[127:96]);
  mixcolumn mc1(sreg[95:64],  alarm, mixedcols[95:64]);
  mixcolumn mc2(sreg[63:32],  alarm, mixedcols[63:32]);
  mixcolumn mc3(sreg[31:0],   alarm, mixedcols[31:0]);
endmodule