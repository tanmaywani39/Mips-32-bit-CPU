module PC(
    input clk, 
    input reset, 
    input PCWrite,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            pc_out <= 32'b0;
        else if (PCWrite) 
            pc_out <= pc_in;
    end
endmodule
