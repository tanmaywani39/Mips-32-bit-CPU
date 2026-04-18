module ForwardUnit(
    input [4:0] EX_RN1, 
    input [4:0] EX_RN2,
    input [4:0] MEM_WN, 
    input [4:0] WB_WN,
    input MEM_RegWrite, 
    input WB_RegWrite,
    output reg [1:0] ForwardA, 
    output reg [1:0] ForwardB
);
    always @(*) begin
        // Default: no forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        
        // EX hazard (forward from MEM stage)
        if (MEM_RegWrite && MEM_WN != 5'b0 && MEM_WN == EX_RN1) begin
            ForwardA = 2'b10;
        end
        // MEM hazard (forward from WB stage)
        else if (WB_RegWrite && WB_WN != 5'b0 && WB_WN == EX_RN1) begin
            ForwardA = 2'b01;
        end
        
        // EX hazard (forward from MEM stage)
        if (MEM_RegWrite && MEM_WN != 5'b0 && MEM_WN == EX_RN2) begin
            ForwardB = 2'b10;
        end
        // MEM hazard (forward from WB stage)
        else if (WB_RegWrite && WB_WN != 5'b0 && WB_WN == EX_RN2) begin
            ForwardB = 2'b01;
        end
    end
endmodule
