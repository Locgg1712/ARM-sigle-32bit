module condlogic (
    input logic clk, reset, RegW, MemW, PCS,
    input logic [3:0] Cond, ALUFlags,
    input logic [1:0] FlagW,
    output logic RegWrite, MemWrite, PCSrc
);
    logic [3:0] Flags;
    logic [1:0] FlagWrite;
    logic CondEx, execute;
    condcheck check_i(.Cond(Cond), .Flags(Flags), .CondEx(CondEx));
    assign execute = CondEx && !reset;
    assign RegWrite = RegW && execute;
    assign MemWrite = MemW && execute;
    assign PCSrc = PCS && execute;
    assign FlagWrite = FlagW & {2{execute}};
    flopenr nz(.clk(clk), .reset(reset), .en(FlagWrite[1]), .d(ALUFlags[3:2]), .q(Flags[3:2]));
    flopenr cv(.clk(clk), .reset(reset), .en(FlagWrite[0]), .d(ALUFlags[1:0]), .q(Flags[1:0]));
endmodule
