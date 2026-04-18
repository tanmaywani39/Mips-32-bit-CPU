module HazardUnit(
    input [4:0] ID_RN1, 
    input [4:0] ID_RN2,
    input [4:0] EX_WN,
    input EX_MemRead,
    input Branch,
    input Jump,
    output reg PCWrite, 
    output reg IFIDWrite, 
    output reg Stall
);
    always @(*) begin
        // Default: no stall
        PCWrite = 1'b1;
        IFIDWrite = 1'b1;
        Stall = 1'b0;
        
        // Load-use hazard detection
        if (EX_MemRead && ((EX_WN == ID_RN1) || (EX_WN == ID_RN2)) && EX_WN != 5'b0) begin
            PCWrite = 1'b0;
            IFIDWrite = 1'b0;
            Stall = 1'b1;
        end
        
        // Branch/Jump stall (simple approach: stall for 1 cycle)
        // In a more sophisticated design, you might use branch prediction
    end
endmodule
