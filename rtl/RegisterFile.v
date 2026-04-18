module RegisterFile(
    input clk,
    input rst,
    input RegWrite,
    input [4:0] RN1, 
    input [4:0] RN2, 
    input [4:0] WN,
    input [31:0] WD,
    output [31:0] RD1,   // Changed to wire for asynchronous read
    output [31:0] RD2    // Changed to wire for asynchronous read
);
    reg [31:0] Registers [0:31];
    
    // Synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize registers
            Registers[0] <= 32'h00000000;  // $zero always 0
            Registers[1] <= 32'h0000AABB;
            Registers[2] <= 32'h00000005;
            Registers[3] <= 32'h00000003;
            Registers[4] <= 32'h00001034;
            Registers[5] <= 32'h000BACC1;
            Registers[6] <= 32'h000101ED;
            Registers[7] <= 32'h00000007;
            Registers[8] <= 32'h00000008;
            Registers[9] <= 32'h00000009;
            Registers[10] <= 32'd10; Registers[11] <= 32'd11; Registers[12] <= 32'd12;
            Registers[13] <= 32'd13; Registers[14] <= 32'd14; Registers[15] <= 32'd15;
            Registers[16] <= 32'd16; Registers[17] <= 32'd17; Registers[18] <= 32'd18;
            Registers[19] <= 32'd19; Registers[20] <= 32'd20; Registers[21] <= 32'd21;
            Registers[22] <= 32'd22; Registers[23] <= 32'd23; Registers[24] <= 32'd24;
            Registers[25] <= 32'd25; Registers[26] <= 32'd26; Registers[27] <= 32'd27;
            Registers[28] <= 32'd28; Registers[29] <= 32'd29; Registers[30] <= 32'd30;
            Registers[31] <= 32'h0;
        end else if (RegWrite && WN != 5'b0) begin
            Registers[WN] <= WD;
        end
    end
    
    // Asynchronous read (for correct pipeline timing in simulation)
    // Note: For ASIC, synchronous reads are preferred, but require
    // pipeline modifications to account for the 1-cycle read delay
    assign RD1 = Registers[RN1];
    assign RD2 = Registers[RN2];
endmodule
