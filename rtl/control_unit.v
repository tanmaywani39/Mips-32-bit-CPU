module ControlUnit(
    input [5:0] opcode,
    input [5:0] funct,
    input ST,
    output reg RegDst,
    output reg Jump,
    output reg JumpReg,
    output reg Jal,
    output reg ALUSrc,
    output reg [1:0] ALUOp,
    output reg MemRead, 
    output reg MemWrite, 
    output reg MemToReg, 
    output reg RegWrite, 
    output reg Branch, 
    output reg BranchNe
);
    always @(*) begin
        // Default values
        RegDst = 1'b0;
        Jump = 1'b0;
        JumpReg = 1'b0;
        Jal = 1'b0;
        ALUSrc = 1'b0;
        ALUOp = 2'b00;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        Branch = 1'b0;
        BranchNe = 1'b0;
        
        if (!ST) begin
            case (opcode)
                // R-type instructions
                6'b000000: begin
                    if (funct == 6'b001000) begin  // jr
                        JumpReg = 1'b1;
                        RegWrite = 1'b0;
                    end else begin
                        RegDst = 1'b1;
                        ALUOp = 2'b10;
                        RegWrite = 1'b1;
                    end
                end
                
                // I-type: lw
                6'b100011: begin
                    ALUSrc = 1'b1;
                    ALUOp = 2'b00;
                    MemRead = 1'b1;
                    MemToReg = 1'b1;
                    RegWrite = 1'b1;
                    RegDst = 1'b0;
                end
                
                // I-type: sw
                6'b101011: begin
                    ALUSrc = 1'b1;
                    ALUOp = 2'b00;
                    MemWrite = 1'b1;
                end
                
                // I-type: addi
                6'b001000: begin
                    ALUSrc = 1'b1;
                    ALUOp = 2'b00;
                    RegWrite = 1'b1;
                    RegDst = 1'b0;
                end
                
                // I-type: ori
                6'b001101: begin
                    ALUSrc = 1'b1;
                    ALUOp = 2'b11;
                    RegWrite = 1'b1;
                    RegDst = 1'b0;
                end
                
                // I-type: andi
                6'b001100: begin
                    ALUSrc = 1'b1;
                    ALUOp = 2'b11;
                    RegWrite = 1'b1;
                    RegDst = 1'b0;
                end
                
                // I-type: beq
                6'b000100: begin
                    ALUSrc = 1'b0;
                    ALUOp = 2'b01;
                    Branch = 1'b1;
                    BranchNe = 1'b0;
                end
                
                // I-type: bne
                6'b000101: begin
                    ALUSrc = 1'b0;
                    ALUOp = 2'b01;
                    Branch = 1'b1;
                    BranchNe = 1'b1;
                end
                
                // J-type: j
                6'b000010: begin
                    Jump = 1'b1;
                end
                
                // J-type: jal
                6'b000011: begin
                    Jump = 1'b1;
                    Jal = 1'b1;
                    RegWrite = 1'b1;
                end
                
                default: begin
                    // All signals already set to default
                end
            endcase
        end
    end
endmodule
