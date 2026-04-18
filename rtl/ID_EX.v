module ID_EX(
    input clk, 
    input reset,
    input [31:0] pc_in, 
    input [31:0] RD1_in, 
    input [31:0] RD2_in, 
    input [31:0] Imm_in,
    input [4:0] RN1_in, 
    input [4:0] RN2_in,
    input [4:0] rd_in,
    input [4:0] rt_in,
    input [1:0] ALUOp_in,
    input RegDst_in,
    input ALUSrc_in, 
    input MemRead_in, 
    input MemWrite_in, 
    input MemToReg_in, 
    input RegWrite_in,
    input [5:0] funct_in,
    input [5:0] opcode_in,
    input JumpReg_in,
    output reg [31:0] pc_out, 
    output reg [31:0] RD1_out, 
    output reg [31:0] RD2_out, 
    output reg [31:0] Imm_out,
    output reg [4:0] RN1_out, 
    output reg [4:0] RN2_out,
    output reg [4:0] rd_out,
    output reg [4:0] rt_out,
    output reg [1:0] ALUOp_out,
    output reg RegDst_out,
    output reg ALUSrc_out, 
    output reg MemRead_out, 
    output reg MemWrite_out, 
    output reg MemToReg_out, 
    output reg RegWrite_out,
    output reg [5:0] funct_out,
    output reg [5:0] opcode_out,
    output reg JumpReg_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'b0;
            RD1_out <= 32'b0;
            RD2_out <= 32'b0;
            Imm_out <= 32'b0;
            RN1_out <= 5'b0;
            RN2_out <= 5'b0;
            rd_out <= 5'b0;
            rt_out <= 5'b0;
            ALUOp_out <= 2'b0;
            RegDst_out <= 1'b0;
            ALUSrc_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            MemToReg_out <= 1'b0;
            RegWrite_out <= 1'b0;
            funct_out <= 6'b0;
            opcode_out <= 6'b0;
            JumpReg_out <= 1'b0;
        end else begin
            pc_out <= pc_in;
            RD1_out <= RD1_in;
            RD2_out <= RD2_in;
            Imm_out <= Imm_in;
            RN1_out <= RN1_in;
            RN2_out <= RN2_in;
            rd_out <= rd_in;
            rt_out <= rt_in;
            ALUOp_out <= ALUOp_in;
            RegDst_out <= RegDst_in;
            ALUSrc_out <= ALUSrc_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            MemToReg_out <= MemToReg_in;
            RegWrite_out <= RegWrite_in;
            funct_out <= funct_in;
            opcode_out <= opcode_in;
            JumpReg_out <= JumpReg_in;
        end
    end
endmodule
