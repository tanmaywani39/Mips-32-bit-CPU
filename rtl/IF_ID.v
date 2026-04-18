module IF_ID(
    input clk, 
    input reset, 
    input IFIDWrite, 
    input IFIDFlush,
    input [31:0] instr_in, 
    input [31:0] pc_in,
    output reg [31:0] instr_out, 
    output reg [31:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Pure asynchronous reset branch
            instr_out <= 32'b0;
            pc_out <= 32'b0;
        end else begin
            // Synchronous logic (Flush and Write)
            if (IFIDFlush) begin
                instr_out <= 32'b0;
                pc_out <= 32'b0;
            end else if (IFIDWrite) begin
                instr_out <= instr_in;
                pc_out <= pc_in;
            end
        end
    end
endmodule
