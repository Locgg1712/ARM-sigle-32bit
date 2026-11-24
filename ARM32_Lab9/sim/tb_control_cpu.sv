`timescale 1ns/1ps
module tb_control_cpu;
    logic clk=0, reset=1, MemWrite;
    logic [31:0] DataAdr, WriteData;
    top #(.MEMFILE("program/control.dat")) dut(.*);
    always #5 clk=~clk;
    initial #22 reset=0;
    initial #600 $fatal(1,"timeout");
    int stores=0, loops=0;
    logic [31:0] expect_pc=0, here;
    always @(posedge clk) if (!reset) begin
        here=dut.PC;
        if (here !== expect_pc || dut.imem_i.in_range !== 1'b1) $fatal(1,"Unexpected PC %h expected %h",here,expect_pc);
        if ((MemWrite || (dut.cpu.MemtoReg && dut.cpu.RegWrite)) && dut.dmem_i.in_range !== 1'b1)
            $fatal(1,"bad data address");
        expect_pc=here+4;
        case (here)
            'h20: expect_pc='h28;
            'h28: expect_pc='h30;
            'h38: expect_pc='h44;
            'h5c: expect_pc='h5c;
        endcase
        case (here)
            'h0c, 'h10, 'h14, 'h44, 'h48, 'h4c, 'h50:
                if ({dut.cpu.RegWrite,MemWrite,dut.cpu.PCSrc,dut.cpu.c.cl.FlagWrite} !== 0)
                    $fatal(1,"Unexpected side effect at PC=%h",here);
        endcase
        if (MemWrite !== (here=='h34 || here=='h58)) $fatal(1,"Unexpected write enable");
        if (MemWrite) begin
            stores++;
            if (here=='h34 && {DataAdr,WriteData} !== {32'd108,32'd68}) $fatal(1,"store 1");
            if (here=='h58 && {DataAdr,WriteData} !== {32'd112,32'd7}) $fatal(1,"store 2");
        end
        #1;
        if (dut.PC !== expect_pc) $fatal(1,"wrong next PC");
        case (here)
            'h08, 'h0c, 'h18: if (dut.cpu.c.cl.Flags !== 4'b0110) $fatal(1,"NZCV hold/update");
            'h1c: if (dut.cpu.c.cl.Flags !== 4'b0010) $fatal(1,"ORRS flags");
            'h5c: begin
                loops++;
                if (loops == 2) begin
                    if (stores != 2 || dut.cpu.dp.rf.rf[1] !== 5 || dut.dmem_i.RAM[28] !== 7)
                        $fatal(1,"wrong final state");
                    $display("PASS tb_control_cpu: conditions, flags, branch, PC writes, unsupported encodings");
                    $finish;
                end
            end
        endcase
    end
endmodule
