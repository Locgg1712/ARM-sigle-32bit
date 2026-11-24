module arm (
    input logic clk, reset,
    input logic [31:0] Instr, ReadData,
    output logic [31:0] PC, ALUResult, WriteData,
    output logic MemWrite
);
    logic [1:0] RegSrc, ImmSrc, ALUControl;
    logic [3:0] ALUFlags;
    logic ALUSrc, MemtoReg, RegWrite, PCSrc;
    controller c(.clk(clk), .reset(reset), .Instr(Instr), .ALUFlags(ALUFlags),
                 .RegSrc(RegSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl),
                 .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
                 .MemWrite(MemWrite), .PCSrc(PCSrc));
    datapath dp(.clk(clk), .reset(reset), .Instr(Instr), .ReadData(ReadData),
                .RegSrc(RegSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl),
                .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .PCSrc(PCSrc),
                .PC(PC), .ALUResult(ALUResult), .WriteData(WriteData), .ALUFlags(ALUFlags));
endmodule
