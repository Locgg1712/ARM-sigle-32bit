module alu (
    input logic [31:0] a, b,
    input logic [1:0] ALUControl,
    output logic [31:0] Result,
    output logic [3:0] ALUFlags
);
    logic subtract, carry, overflow;
    logic [32:0] sum;
    assign subtract = (ALUControl == 2'b01);
    // A - B = A + ~B + 1. The 33rd bit is the no-borrow flag.
    assign sum = {1'b0, a} + {1'b0, (subtract ? ~b : b)} + {32'b0, subtract};
    always_comb begin
        case (ALUControl)
            2'b00, 2'b01: Result = sum[31:0];
            2'b10:        Result = a & b;
            2'b11:        Result = a | b;
            default:      Result = 'x;
        endcase
    end
    assign carry = !ALUControl[1] && sum[32];
    assign overflow = !ALUControl[1] && (Result[31] ^ a[31]) &&
                      (subtract ? (a[31] ^ b[31]) : (a[31] == b[31]));
    assign ALUFlags = {Result[31], (Result == 0), carry, overflow};
endmodule
