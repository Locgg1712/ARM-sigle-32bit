module controller (
    input logic clk, reset,
    input logic [31:0] Instr,
    input logic [3:0] ALUFlags,
    output logic [1:0] RegSrc, ImmSrc, ALUControl,
    output logic ALUSrc, MemtoReg, RegWrite, MemWrite, PCSrc
);
    logic RegW, MemW, PCS;
    logic [1:0] FlagW;
    decoder dec(.Instr(Instr), .RegSrc(RegSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl),
                .FlagW(FlagW), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegW(RegW), .MemW(MemW), .PCS(PCS));
    condlogic cl(.clk(clk), .reset(reset), .Cond(Instr[31:28]), .ALUFlags(ALUFlags),
                 .RegW(RegW), .MemW(MemW), .PCS(PCS), .FlagW(FlagW),
                 .RegWrite(RegWrite), .MemWrite(MemWrite), .PCSrc(PCSrc));
endmodule
