`timescale 1ns/1ps
module tb_top;
    logic clk = 0, reset = 1;
    logic [31:0] DataAdr, WriteData;
    logic MemWrite;
    top dut(.clk(clk), .reset(reset), .WriteData(WriteData), .DataAdr(DataAdr), .MemWrite(MemWrite));
    always #5 clk = ~clk;
    initial #22 reset = 0;
    initial begin
        if ($test$plusargs("vcd")) begin
            $dumpfile("lab9.vcd");
            $dumpvars(0, tb_top);
        end
        #450 $fatal(1,"Timeout");
    end

    integer step = 0;
    integer stores = 0;
    logic [31:0] expected_pc;
    task automatic check_word(input logic [31:0] actual, expected, input string label);
        if (actual !== expected)
            $fatal(1,"step=%0d %s: got %h expected %h",step,label,actual,expected);
    endtask
    always @(posedge clk) if (!reset) begin
        expected_pc = step < 7 ? 4 * step : 28;
        check_word(dut.PC, expected_pc, "PC");
        if (dut.imem_i.in_range !== 1'b1) $fatal(1,"Invalid fetch");
        if ((MemWrite || (dut.cpu.MemtoReg && dut.cpu.RegWrite)) && dut.dmem_i.in_range !== 1'b1)
            $fatal(1,"Invalid data address");
        check_word(MemWrite, step == 3 || step == 6, "MemWrite");
        check_word(dut.cpu.PCSrc, step >= 7, "PCSrc");
        check_word(dut.cpu.RegWrite, step == 0 || step == 1 || step == 2 || step == 4 || step == 5, "RegWrite");
        if (MemWrite) begin
            check_word(DataAdr, step == 3 ? 100 : 104, "store address");
            check_word(WriteData, step == 3 ? 8 : 3, "store data");
            stores++;
            $display("PC=%0d  DMEM[%0d] <- %0d", dut.PC, DataAdr, WriteData);
        end
        if (step == 4) begin
            check_word(DataAdr,100,"LDR address");
            check_word(dut.ReadData,8,"LDR ReadData");
            check_word(dut.cpu.dp.Result,8,"LDR writeback");
        end
        #1; // Sample after the nonblocking state updates.
        case (step)
            0: check_word(dut.cpu.dp.rf.rf[0],0,"R0");
            1: check_word(dut.cpu.dp.rf.rf[1],5,"R1");
            2: check_word(dut.cpu.dp.rf.rf[2],8,"R2");
            3: check_word(dut.dmem_i.RAM[25],8,"RAM[25]");
            4: check_word(dut.cpu.dp.rf.rf[3],8,"R3");
            5: check_word(dut.cpu.dp.rf.rf[4],3,"R4");
            6: check_word(dut.dmem_i.RAM[26],3,"RAM[26]");
            default: check_word(dut.PC,28,"terminal branch");
        endcase
        if (step == 9) begin
            check_word(stores,2,"store count");
            $display("PASS tb_top: 100 <- 8, 104 <- 3, PC loops at 28");
            $finish;
        end
        step++;
    end
endmodule
