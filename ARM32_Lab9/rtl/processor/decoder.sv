module decoder (
    input logic [31:0] Instr,
    output logic [1:0] RegSrc, ImmSrc, ALUControl, FlagW,
    output logic ALUSrc, MemtoReg, RegW, MemW, PCS
);
    logic Branch, valid_operand;
    // DP accepts either imm8 (rotate=0) or unshifted Rm.
    assign valid_operand = Instr[25] ? (Instr[11:8] == 0) : (Instr[11:4] == 0);
    always_comb begin
        RegSrc = 0;
        ImmSrc = 0;
        ALUSrc = 0;
        MemtoReg = 0;
        ALUControl = 0;
        RegW = 0;
        MemW = 0;
        Branch = 0;
        FlagW = 0;
        case (Instr[27:26])
            2'b00: if (valid_operand && !(Instr[20] && Instr[15:12] == 4'd15)) begin
                // S=1 with Rd=PC has exception-return semantics outside this lab.
                ALUSrc = Instr[25];
                case (Instr[24:21])
                    4'b0100: begin RegW = 1; ALUControl = 2'b00; end // ADD
                    4'b0010: begin RegW = 1; ALUControl = 2'b01; end // SUB
                    4'b0000: begin RegW = 1; ALUControl = 2'b10; end // AND
                    4'b1100: begin RegW = 1; ALUControl = 2'b11; end // ORR
                    default: ;
                endcase
                if (RegW && Instr[20])
                    FlagW = ALUControl[1] ? 2'b10 : 2'b11;
            end
            2'b01: if (Instr[25:21] == 5'b01100) begin
                // I/P/U/B/W = 0/1/1/0/0. L is bit 20.
                ImmSrc = 2'b01;
                ALUSrc = 1;
                if (Instr[20]) begin
                    MemtoReg = 1;
                    RegW = 1;
                end else begin
                    RegSrc = 2'b10;
                    MemW = 1;
                end
            end
            2'b10: if (Instr[25:24] == 2'b10) begin // B, link=0
                RegSrc = 2'b01;
                ImmSrc = 2'b10;
                ALUSrc = 1;
                Branch = 1;
            end
            default: ;
        endcase
    end
    assign PCS = Branch || (RegW && Instr[15:12] == 4'd15);
endmodule
