module regfile (
    input logic clk, we3,
    input logic [3:0] ra1, ra2, wa3,
    input logic [31:0] wd3, pc_plus_8,
    output logic [31:0] rd1, rd2
);
    logic [31:0] rf [0:14];
    // R15 is supplied by the PC path; it has no cell in this array.
    assign rd1 = (ra1 == 4'd15) ? pc_plus_8 : rf[ra1];
    assign rd2 = (ra2 == 4'd15) ? pc_plus_8 : rf[ra2];
    always_ff @(posedge clk)
        if (we3 && wa3 != 4'd15) rf[wa3] <= wd3;
endmodule
