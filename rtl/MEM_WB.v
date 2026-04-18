module MEM_WB(
    input clk, 
    input reset,
    input [31:0] alu_result_in, 
    input [31:0] mem_data_in,
    input [31:0] pc_in,
    input [4:0] WN_in,
    input MemToReg_in, 
    input RegWrite_in,
    output reg [31:0] alu_result_out, 
    output reg [31:0] mem_data_out,
    output reg [31:0] pc_out,
    output reg [4:0] WN_out,
    output reg MemToReg_out, 
    output reg RegWrite_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            mem_data_out <= 32'b0;
            pc_out <= 32'b0;
            WN_out <= 5'b0;
            MemToReg_out <= 1'b0;
            RegWrite_out <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            mem_data_out <= mem_data_in;
            pc_out <= pc_in;
            WN_out <= WN_in;
            MemToReg_out <= MemToReg_in;
            RegWrite_out <= RegWrite_in;
        end
    end
endmodule
