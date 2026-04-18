module EX_MEM(
    input clk, 
    input reset,
    input [31:0] alu_result_in, 
    input [31:0] RD2_in,
    input [31:0] pc_in,
    input [4:0] WN_in,
    input MemRead_in, 
    input MemWrite_in, 
    input MemToReg_in, 
    input RegWrite_in,
    input Zero_in,
    input JumpReg_in,
    output reg [31:0] alu_result_out, 
    output reg [31:0] RD2_out,
    output reg [31:0] pc_out,
    output reg [4:0] WN_out,
    output reg MemRead_out, 
    output reg MemWrite_out, 
    output reg MemToReg_out, 
    output reg RegWrite_out,
    output reg Zero_out,
    output reg JumpReg_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            RD2_out <= 32'b0;
            pc_out <= 32'b0;
            WN_out <= 5'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            MemToReg_out <= 1'b0;
            RegWrite_out <= 1'b0;
            Zero_out <= 1'b0;
            JumpReg_out <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            RD2_out <= RD2_in;
            pc_out <= pc_in;
            WN_out <= WN_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            MemToReg_out <= MemToReg_in;
            RegWrite_out <= RegWrite_in;
            Zero_out <= Zero_in;
            JumpReg_out <= JumpReg_in;
        end
    end
endmodule
