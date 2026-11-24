`timescale 1ns/1ps
module tb_units;
    logic [31:0] a, b, Result;
    logic [1:0] ALUControl;
    logic [3:0] ALUFlags, Cond, Flags;
    logic CondEx;
    logic [15:0] expected;
    alu alu_i(.*);
    condcheck check_i(.*);
    task automatic check_alu(input logic [1:0] op, input logic [31:0] x,y,r, input logic [3:0] nzcv);
        ALUControl=op; a=x; b=y; #1;
        if (Result !== r || ALUFlags !== nzcv)
            $fatal(1,"ALU op=%d A=%h B=%h result=%h flags=%b",op,a,b,Result,ALUFlags);
    endtask
    initial begin
        check_alu(0,5,8,13,0);
        check_alu(0,32'hffffffff,1,0,4'b0110);
        check_alu(0,32'h7fffffff,1,32'h80000000,4'b1001);
        check_alu(0,32'h80000000,32'h80000000,0,4'b0111);
        check_alu(1,3,5,32'hfffffffe,4'b1000);
        check_alu(1,5,3,2,4'b0010);
        check_alu(1,5,5,0,4'b0110);
        check_alu(1,32'h80000000,1,32'h7fffffff,4'b0011);
        check_alu(2,5,3,1,0);
        check_alu(3,5,3,7,0);
        for (int i=0; i<16; i++) begin
            Flags=i;
            // Bit k of each mask gives the expected result for condition k.
            case (i)
                0: expected=16'h56aa;
                1: expected=16'h6a6a;
                2: expected=16'h55a6;
                3: expected=16'h6966;
                4: expected=16'h66a9;
                5: expected=16'h6a69;
                6: expected=16'h66a5;
                7: expected=16'h6a65;
                8: expected=16'h6a9a;
                9: expected=16'h565a;
                10: expected=16'h6996;
                11: expected=16'h5556;
                12: expected=16'h6a99;
                13: expected=16'h6659;
                14: expected=16'h6a95;
                15: expected=16'h6655;
            endcase
            for (int k=0; k<16; k++) begin
                Cond=k; #1;
                if (CondEx !== expected[k]) $fatal(1,"Cond=%h Flags=%b",Cond,Flags);
            end
        end
        $display("PASS tb_units: ALU arithmetic/logic and 256 condition/flags combinations");
        $finish;
    end
endmodule
