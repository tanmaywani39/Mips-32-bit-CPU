module InstructionMemory(
    input clk,
    input rst,
    input EnIM,
    input [31:0] addr,
    output reg [31:0] instr
);
    reg [7:0] IM [0:255];  // 256 bytes = 64 instructions (32-bit each)
    
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize all to zero first
            for (i = 0; i < 256; i = i + 1)
                IM[i] <= 8'h00;
            
            // R-type: add $6, $1, $2  (00000001 00000010 00110000 00100000)
            IM[0]<=8'h00; IM[1]<=8'h22; IM[2]<=8'h30; IM[3]<=8'h20;
            // R-type: sub $8, $3, $4  (00000011 00000100 01000000 00100010)
            IM[4]<=8'h00; IM[5]<=8'h64; IM[6]<=8'h40; IM[7]<=8'h22;
            // R-type: and $10, $6, $7 (00000110 00000111 01010000 00100100)
            IM[8]<=8'h00; IM[9]<=8'hC7; IM[10]<=8'h50; IM[11]<=8'h24;
            // R-type: or $12, $8, $9  (00001000 00001001 01100000 00100101)
            IM[12]<=8'h01; IM[13]<=8'h09; IM[14]<=8'h60; IM[15]<=8'h25;
            // R-type: slt $14, $10, $11 (00001010 00001011 01110000 00101010)
            IM[16]<=8'h01; IM[17]<=8'h4B; IM[18]<=8'h70; IM[19]<=8'h2A;
            // I-type: addi $15, $12, 10 (00100001 10001111 00000000 00001010)
            IM[20]<=8'h21; IM[21]<=8'h8F; IM[22]<=8'h00; IM[23]<=8'h0A;
            // I-type: ori $16, $13, 255 (00110101 10110000 00000000 11111111)
            IM[24]<=8'h35; IM[25]<=8'hB0; IM[26]<=8'h00; IM[27]<=8'hFF;
            // I-type: lw $17, 0($14)   (10001101 11010001 00000000 00000000)
            IM[28]<=8'h8D; IM[29]<=8'hD1; IM[30]<=8'h00; IM[31]<=8'h00;
            // I-type: sw $17, 4($14)   (10101101 11010001 00000000 00000100)
            IM[32]<=8'hAD; IM[33]<=8'hD1; IM[34]<=8'h00; IM[35]<=8'h04;
            // I-type: beq $15, $16, 2  (00010001 11110000 00000000 00000010)
            IM[36]<=8'h11; IM[37]<=8'hF0; IM[38]<=8'h00; IM[39]<=8'h02;
            // I-type: bne $15, $16, 1  (00010101 11110000 00000000 00000001)
            IM[40]<=8'h15; IM[41]<=8'hF0; IM[42]<=8'h00; IM[43]<=8'h01;
            // J-type: j 20             (00001000 00000000 00000000 00010100)
            IM[44]<=8'h08; IM[45]<=8'h00; IM[46]<=8'h00; IM[47]<=8'h14;
            // J-type: jal 24           (00001100 00000000 00000000 00011000)
            IM[48]<=8'h0C; IM[49]<=8'h00; IM[50]<=8'h00; IM[51]<=8'h18;
            // R-type: jr $31           (00111111 11100000 00000000 00001000)
            IM[52]<=8'h03; IM[53]<=8'hE0; IM[54]<=8'h00; IM[55]<=8'h08;
            // Bytes 56-255: already zeroed by the for loop above (NOP slots)
            
            instr <= 32'b0;
        end else if (EnIM) begin
            instr <= {IM[addr[7:0]], IM[addr[7:0]+1], IM[addr[7:0]+2], IM[addr[7:0]+3]};
        end
    end
endmodule
