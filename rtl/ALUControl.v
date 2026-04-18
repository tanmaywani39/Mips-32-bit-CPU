module ALUControl(
    input [1:0] ALUOp,
    input [5:0] funct,
    input [5:0] opcode,
    output reg [3:0] ALUControlSignal
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControlSignal = 4'b0010;  // ADD (for lw/sw/addi)
            2'b01: ALUControlSignal = 4'b0110;  // SUB (for beq/bne)
            2'b10: begin  // R-type
                case (funct)
                    6'b100000: ALUControlSignal = 4'b0010;  // add
                    6'b100010: ALUControlSignal = 4'b0110;  // sub
                    6'b100100: ALUControlSignal = 4'b0000;  // and
                    6'b100101: ALUControlSignal = 4'b0001;  // or
                    6'b101010: ALUControlSignal = 4'b0111;  // slt
                    6'b100110: ALUControlSignal = 4'b1100;  // xor
                    6'b100111: ALUControlSignal = 4'b1101;  // nor
                    6'b000000: ALUControlSignal = 4'b1000;  // sll
                    6'b000010: ALUControlSignal = 4'b1001;  // srl
                    default: ALUControlSignal = 4'b0000;
                endcase
            end
            2'b11: begin  // I-type (ori/andi)
                case (opcode)
                    6'b001101: ALUControlSignal = 4'b0001;  // ori
                    6'b001100: ALUControlSignal = 4'b0000;  // andi
                    default: ALUControlSignal = 4'b0000;
                endcase
            end
            default: ALUControlSignal = 4'b0000;
        endcase
    end
endmodule
