module DataMemory(
    input clk,
    input MemRead, 
    input MemWrite,
    input [31:0] addr,
    input [31:0] WriteData,
    output reg [31:0] ReadData
);
    reg [31:0] mem [0:255];
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = i * 4;
        end
    end
    
    // Synchronous read and write
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[addr[9:2]] <= WriteData;  // Word-aligned
        end
        
        if (MemRead) begin
            ReadData <= mem[addr[9:2]];   // Word-aligned
        end
    end
endmodule
