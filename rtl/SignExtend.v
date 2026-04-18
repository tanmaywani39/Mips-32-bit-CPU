module SignExtend(
    input [15:0] imm, 
    output [31:0] out
);
    assign out = {{16{imm[15]}}, imm};
endmodule
