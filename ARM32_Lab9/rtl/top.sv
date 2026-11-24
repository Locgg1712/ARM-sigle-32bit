module top #(parameter MEMFILE = "program/memfile.dat") (
    input logic clk, reset,
    output logic [31:0] WriteData, DataAdr,
    output logic MemWrite
);
    logic [31:0] PC, Instr, ReadData;
    arm cpu(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr),
            .ALUResult(DataAdr), .WriteData(WriteData), .MemWrite(MemWrite), .ReadData(ReadData));
    imem #(.MEMFILE(MEMFILE)) imem_i(.a(PC), .rd(Instr));
    dmem dmem_i(.clk(clk), .we(MemWrite), .a(DataAdr), .wd(WriteData), .rd(ReadData));
endmodule
