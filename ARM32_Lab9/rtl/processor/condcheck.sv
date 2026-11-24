module condcheck (
    input logic [3:0] Cond, Flags,
    output logic CondEx
);
    logic n, z, c, v;
    assign {n,z,c,v} = Flags;
    always_comb begin
        case (Cond)
            4'h0: CondEx = z;               // EQ
            4'h1: CondEx = !z;              // NE
            4'h2: CondEx = c;               // CS
            4'h3: CondEx = !c;              // CC
            4'h4: CondEx = n;               // MI
            4'h5: CondEx = !n;              // PL
            4'h6: CondEx = v;               // VS
            4'h7: CondEx = !v;              // VC
            4'h8: CondEx = c && !z;         // HI
            4'h9: CondEx = !c || z;         // LS
            4'hA: CondEx = (n == v);        // GE
            4'hB: CondEx = (n != v);        // LT
            4'hC: CondEx = !z && (n == v);  // GT
            4'hD: CondEx = z || (n != v);   // LE
            4'hE: CondEx = 1;               // AL
            default: CondEx = 0;
        endcase
    end
endmodule
