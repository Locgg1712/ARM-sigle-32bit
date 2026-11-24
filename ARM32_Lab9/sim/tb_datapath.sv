`timescale 1ns/1ps
module tb_datapath;
    logic clk=0, reset=0;
    logic [31:0] Instr, ReadData, PC, ALUResult, WriteData;
    logic [1:0] RegSrc, ImmSrc, ALUControl;
    logic ALUSrc, MemtoReg, RegWrite, PCSrc;
    logic [3:0] ALUFlags;
    datapath dp(.*);
    task automatic tick;
        #2 clk=1;
        #2 clk=0;
    endtask
    initial begin
        reset=1; {RegSrc,ImmSrc,ALUControl,ALUSrc,MemtoReg,RegWrite,PCSrc}='0;
        Instr=0; ReadData=0; tick();
        if (PC !== 0) $fatal(1,"PC reset");
        reset=0; Instr=32'hE04F000F; ALUControl=1; RegWrite=1;
        #1;
        if (dp.SrcA !== 8 || dp.SrcB !== 8 || ALUResult !== 0) $fatal(1,"R15-R15");
        tick();
        if (PC !== 4) $fatal(1,"sequential PC");
        Instr=32'hE2801005; ALUSrc=1; ALUControl=0;
        #1;
        if (dp.ExtImm !== 5 || ALUResult !== 5) $fatal(1,"immediate");
        tick();
        Instr=32'hE0812001; ALUSrc=0; // ADD R2,R1,R1
        #1;
        if (dp.SrcA !== 5 || dp.SrcB !== 5 || ALUResult !== 10) $fatal(1,"register ADD");
        tick();
        Instr=32'hE5903060; ImmSrc=1; ALUSrc=1; MemtoReg=1; ReadData=37;
        #1;
        if (ALUResult !== 96 || dp.Result !== 37) $fatal(1,"LDR");
        tick();
        Instr=32'hE5803060; RegWrite=0; RegSrc=2; MemtoReg=0;
        #1;
        if (WriteData !== 37 || dp.SrcB !== 96 || dp.RA2 !== 3) $fatal(1,"STR");
        tick();
        Instr=32'hEAFFFFFE; RegSrc=1; ImmSrc=2; PCSrc=1;
        #1;
        if (dp.RA1 !== 15 || dp.ExtImm !== 32'hFFFFFFF8 || dp.PCNext !== 20) $fatal(1,"B path");
        tick();
        if (PC !== 20) $fatal(1,"B latch");
        $display("PASS tb_datapath: independent PC, DP register/immediate, LDR, STR, B");
        $finish;
    end
endmodule
