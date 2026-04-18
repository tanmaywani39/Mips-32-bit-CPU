module topm(
    input clk, 
    input reset,
    output [31:0] alu_result_out,  // Changed to wire for immediate observation
    output [31:0] pc_out           // Changed to wire for immediate observation
);
    // ========== IF Stage ==========
    wire [31:0] pc_current, pc_next, pc_plus4, instr_if;
    wire PCWrite, IFIDWrite, Stall;
    
    // ========== ID Stage ==========
    wire [31:0] instr_id, pc_id;
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd;
    wire [15:0] imm16;
    wire [25:0] jump_addr;
    wire [31:0] imm_ext;
    wire [31:0] RD1, RD2;
    wire RegDst, Jump, JumpReg, Jal, ALUSrc;
    wire [1:0] ALUOp;
    wire MemRead, MemWrite, MemToReg, RegWrite, Branch, BranchNe;
    wire IFIDFlush;
    wire [1:0] ID_FA, ID_FB;
    wire [31:0] branch_src1, branch_src2;
    wire branch_taken;
    wire [31:0] branch_target, jump_target;
    
    // ========== EX Stage ==========
    wire [31:0] pc_ex, RD1_ex, RD2_ex, imm_ex;
    wire [4:0] RN1_ex, RN2_ex, rd_ex, rt_ex, WN_ex;
    wire [1:0] ALUOp_ex;
    wire RegDst_ex, ALUSrc_ex, MemRead_ex, MemWrite_ex;
    wire MemToReg_ex, RegWrite_ex, JumpReg_ex;
    wire [5:0] funct_ex, opcode_ex;
    wire [1:0] ForwardA, ForwardB;
    wire [31:0] alu_in1, alu_in2, alu_in2_final;
    wire [31:0] alu_result;
    wire [3:0] ALUControlSignal;
    wire Zero;
    
    // ========== MEM Stage ==========
    wire [31:0] alu_result_mem, RD2_mem, pc_mem;
    wire [4:0] WN_mem;
    wire MemRead_mem, MemWrite_mem, MemToReg_mem, RegWrite_mem;
    wire Zero_mem, JumpReg_mem;
    wire [31:0] mem_read_data;
    
    // ========== WB Stage ==========
    wire [31:0] alu_result_wb, mem_data_wb, pc_wb;
    wire [4:0] WN_wb;
    wire MemToReg_wb, RegWrite_wb;
    wire [31:0] write_data;
    
    // ========== IF Stage Implementation ==========
    assign pc_plus4 = pc_current + 4;
    
    // Jump target calculation
    assign jump_target = {pc_plus4[31:28], jump_addr, 2'b00};
    
    // Branch target calculation
    assign branch_target = pc_id + (imm_ext << 2);
    
    // PC source selection
    assign pc_next = JumpReg_mem ? alu_result_mem :  // jr
                     Jump ? jump_target :              // j/jal
                     branch_taken ? branch_target :    // beq/bne
                     pc_plus4;                         // normal increment
    
    PC pc_inst(
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .pc_in(pc_next),
        .pc_out(pc_current)
    );
    
    InstructionMemory imem(
        .clk(clk),
        .rst(reset),
        .EnIM(1'b1),
        .addr(pc_current),
        .instr(instr_if)
    );
    
    IF_ID ifid(
        .clk(clk),
        .reset(reset),
        .IFIDWrite(IFIDWrite),
        .IFIDFlush(IFIDFlush),
        .instr_in(instr_if),
        .pc_in(pc_current),
        .instr_out(instr_id),
        .pc_out(pc_id)
    );
    
    // ========== ID Stage Implementation ==========
    assign opcode = instr_id[31:26];
    assign rs = instr_id[25:21];
    assign rt = instr_id[20:16];
    assign rd = instr_id[15:11];
    assign imm16 = instr_id[15:0];
    assign funct = instr_id[5:0];
    assign jump_addr = instr_id[25:0];
    
    ControlUnit cu(
        .opcode(opcode),
        .funct(funct),
        .ST(Stall),
        .RegDst(RegDst),
        .Jump(Jump),
        .JumpReg(JumpReg),
        .Jal(Jal),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite),
        .Branch(Branch),
        .BranchNe(BranchNe)
    );
    
    // Write register selection for JAL
    wire [4:0] final_write_reg = Jal ? 5'd31 : WN_wb;
    wire [31:0] final_write_data = Jal ? pc_wb + 4 : write_data;
    
    RegisterFile rf(
        .clk(clk),
        .rst(reset),
        .RegWrite(RegWrite_wb),
        .RN1(rs),
        .RN2(rt),
        .WN(final_write_reg),
        .WD(final_write_data),
        .RD1(RD1),
        .RD2(RD2)
    );
    
    SignExtend se(
        .imm(imm16),
        .out(imm_ext)
    );
    
    BranchForwardUnit branch_fwd(
        .ID_RN1(rs),
        .ID_RN2(rt),
        .EX_WN(WN_ex),
        .MEM_WN(WN_mem),
        .WB_WN(WN_wb),
        .EX_RegWrite(RegWrite_ex),
        .MEM_RegWrite(RegWrite_mem),
        .WB_RegWrite(RegWrite_wb),
        .ID_FA(ID_FA),
        .ID_FB(ID_FB)
    );
    
    // Branch forwarding muxes
    assign branch_src1 = (ID_FA == 2'b11) ? alu_result :
                         (ID_FA == 2'b10) ? alu_result_mem :
                         (ID_FA == 2'b01) ? write_data : RD1;
                         
    assign branch_src2 = (ID_FB == 2'b11) ? alu_result :
                         (ID_FB == 2'b10) ? alu_result_mem :
                         (ID_FB == 2'b01) ? write_data : RD2;
    
    // Branch decision
    assign branch_taken = Branch & (BranchNe ? (branch_src1 != branch_src2) : 
                                               (branch_src1 == branch_src2));
    
    assign IFIDFlush = branch_taken | Jump;
    
    HazardUnit hazard(
        .ID_RN1(rs),
        .ID_RN2(rt),
        .EX_WN(WN_ex),
        .EX_MemRead(MemRead_ex),
        .Branch(Branch),
        .Jump(Jump),
        .PCWrite(PCWrite),
        .IFIDWrite(IFIDWrite),
        .Stall(Stall)
    );
    
    ID_EX idex(
        .clk(clk),
        .reset(reset | Stall),  // Flush on stall
        .pc_in(pc_id),
        .RD1_in(RD1),
        .RD2_in(RD2),
        .Imm_in(imm_ext),
        .RN1_in(rs),
        .RN2_in(rt),
        .rd_in(rd),
        .rt_in(rt),
        .ALUOp_in(ALUOp),
        .RegDst_in(RegDst),
        .ALUSrc_in(ALUSrc),
        .MemRead_in(MemRead),
        .MemWrite_in(MemWrite),
        .MemToReg_in(MemToReg),
        .RegWrite_in(RegWrite),
        .funct_in(funct),
        .opcode_in(opcode),
        .JumpReg_in(JumpReg),
        .pc_out(pc_ex),
        .RD1_out(RD1_ex),
        .RD2_out(RD2_ex),
        .Imm_out(imm_ex),
        .RN1_out(RN1_ex),
        .RN2_out(RN2_ex),
        .rd_out(rd_ex),
        .rt_out(rt_ex),
        .ALUOp_out(ALUOp_ex),
        .RegDst_out(RegDst_ex),
        .ALUSrc_out(ALUSrc_ex),
        .MemRead_out(MemRead_ex),
        .MemWrite_out(MemWrite_ex),
        .MemToReg_out(MemToReg_ex),
        .RegWrite_out(RegWrite_ex),
        .funct_out(funct_ex),
        .opcode_out(opcode_ex),
        .JumpReg_out(JumpReg_ex)
    );
    
    // ========== EX Stage Implementation ==========
    ForwardUnit fwd(
        .EX_RN1(RN1_ex),
        .EX_RN2(RN2_ex),
        .MEM_WN(WN_mem),
        .WB_WN(WN_wb),
        .MEM_RegWrite(RegWrite_mem),
        .WB_RegWrite(RegWrite_wb),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    
    // Forwarding muxes
    assign alu_in1 = (ForwardA == 2'b10) ? alu_result_mem :
                     (ForwardA == 2'b01) ? write_data : RD1_ex;
                     
    assign alu_in2 = (ForwardB == 2'b10) ? alu_result_mem :
                     (ForwardB == 2'b01) ? write_data : RD2_ex;
    
    // ALUSrc mux
    assign alu_in2_final = ALUSrc_ex ? imm_ex : alu_in2;
    
    // Write register selection
    assign WN_ex = RegDst_ex ? rd_ex : rt_ex;
    
    ALUControl alu_ctrl(
        .ALUOp(ALUOp_ex),
        .funct(funct_ex),
        .opcode(opcode_ex),
        .ALUControlSignal(ALUControlSignal)
    );
    
    ALU alu(
        .A(alu_in1),
        .B(alu_in2_final),
        .ALUControl(ALUControlSignal),
        .Result(alu_result),
        .Zero(Zero)
    );
    
    EX_MEM exmem(
        .clk(clk),
        .reset(reset),
        .alu_result_in(alu_result),
        .RD2_in(alu_in2),
        .pc_in(pc_ex),
        .WN_in(WN_ex),
        .MemRead_in(MemRead_ex),
        .MemWrite_in(MemWrite_ex),
        .MemToReg_in(MemToReg_ex),
        .RegWrite_in(RegWrite_ex),
        .Zero_in(Zero),
        .JumpReg_in(JumpReg_ex),
        .alu_result_out(alu_result_mem),
        .RD2_out(RD2_mem),
        .pc_out(pc_mem),
        .WN_out(WN_mem),
        .MemRead_out(MemRead_mem),
        .MemWrite_out(MemWrite_mem),
        .MemToReg_out(MemToReg_mem),
        .RegWrite_out(RegWrite_mem),
        .Zero_out(Zero_mem),
        .JumpReg_out(JumpReg_mem)
    );
    
    // ========== MEM Stage Implementation ==========
    DataMemory dmem(
        .clk(clk),
        .MemRead(MemRead_mem),
        .MemWrite(MemWrite_mem),
        .addr(alu_result_mem),
        .WriteData(RD2_mem),
        .ReadData(mem_read_data)
    );
    
    MEM_WB memwb(
        .clk(clk),
        .reset(reset),
        .alu_result_in(alu_result_mem),
        .mem_data_in(mem_read_data),
        .pc_in(pc_mem),
        .WN_in(WN_mem),
        .MemToReg_in(MemToReg_mem),
        .RegWrite_in(RegWrite_mem),
        .alu_result_out(alu_result_wb),
        .mem_data_out(mem_data_wb),
        .pc_out(pc_wb),
        .WN_out(WN_wb),
        .MemToReg_out(MemToReg_wb),
        .RegWrite_out(RegWrite_wb)
    );
    
    // ========== WB Stage Implementation ==========
    assign write_data = MemToReg_wb ? mem_data_wb : alu_result_wb;
    
    // Output assignments (combinational for immediate observation)
    assign alu_result_out = alu_result;
    assign pc_out = pc_current;

endmodule
