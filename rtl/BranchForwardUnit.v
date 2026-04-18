module BranchForwardUnit(
    input [4:0] ID_RN1, 
    input [4:0] ID_RN2,
    input [4:0] EX_WN,
    input [4:0] MEM_WN, 
    input [4:0] WB_WN,
    input EX_RegWrite,
    input MEM_RegWrite, 
    input WB_RegWrite,
    output reg [1:0] ID_FA, 
    output reg [1:0] ID_FB
);
    always @(*) begin
        // Default: no forwarding
        ID_FA = 2'b00;
        ID_FB = 2'b00;
        
        // Forward for RN1
        if (EX_RegWrite && EX_WN == ID_RN1 && EX_WN != 5'b0) begin
            ID_FA = 2'b11;  // From EX stage
        end else if (MEM_RegWrite && MEM_WN == ID_RN1 && MEM_WN != 5'b0) begin
            ID_FA = 2'b10;  // From MEM stage
        end else if (WB_RegWrite && WB_WN == ID_RN1 && WB_WN != 5'b0) begin
            ID_FA = 2'b01;  // From WB stage
        end
        
        // Forward for RN2
        if (EX_RegWrite && EX_WN == ID_RN2 && EX_WN != 5'b0) begin
            ID_FB = 2'b11;  // From EX stage
        end else if (MEM_RegWrite && MEM_WN == ID_RN2 && MEM_WN != 5'b0) begin
            ID_FB = 2'b10;  // From MEM stage
        end else if (WB_RegWrite && WB_WN == ID_RN2 && WB_WN != 5'b0) begin
            ID_FB = 2'b01;  // From WB stage
        end
    end
endmodule
