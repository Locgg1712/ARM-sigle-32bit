module datapath (
    input logic clk, reset,
    input logic [31:0] Instr, ReadData,
    input logic [1:0] RegSrc, ImmSrc, ALUControl,
    input logic ALUSrc, MemtoReg, RegWrite, PCSrc,
    output logic [31:0] PC, ALUResult, WriteData,
    output logic [3:0] ALUFlags
);
    logic [31:0] PCNext, PCPlus4, PCPlus8, SrcA, SrcB, ExtImm, Result;
    logic [3:0] RA1, RA2;
    assign PCPlus4 = PC + 32'd4;
    assign PCPlus8 = PC + 32'd8;
    mux2 next_pc(.d0(PCPlus4), .d1(Result), .sel(PCSrc), .y(PCNext));
    flopr pc_reg(.clk(clk), .reset(reset), .d(PCNext), .q(PC));

    mux2 #(.WIDTH(4)) read_addr1(.d0(Instr[19:16]), .d1(4'd15), .sel(RegSrc[0]), .y(RA1));
    mux2 #(.WIDTH(4)) read_addr2(.d0(Instr[3:0]), .d1(Instr[15:12]), .sel(RegSrc[1]), .y(RA2));
    regfile rf(.clk(clk), .we3(RegWrite), .ra1(RA1), .ra2(RA2),
               .wa3(Instr[15:12]), .wd3(Result), .pc_plus_8(PCPlus8),
               .rd1(SrcA), .rd2(WriteData));

    extend ext(.Instr(Instr[23:0]), .ImmSrc(ImmSrc), .ExtImm(ExtImm));
    mux2 operand_b(.d0(WriteData), .d1(ExtImm), .sel(ALUSrc), .y(SrcB));
    alu alu_i(.a(SrcA), .b(SrcB), .ALUControl(ALUControl),
              .Result(ALUResult), .ALUFlags(ALUFlags));
    mux2 writeback(.d0(ALUResult), .d1(ReadData), .sel(MemtoReg), .y(Result));
endmodule
