module dmem (
    input logic clk, we,
    input logic [31:0] a, wd,
    output logic [31:0] rd
);
    logic [31:0] RAM [0:63];
    logic in_range;
    assign in_range = (a[31:8] == 0) && (a[1:0] == 0);
    assign rd = in_range ? RAM[a[7:2]] : 32'bx;
    always_ff @(posedge clk)
        if (we && in_range) RAM[a[7:2]] <= wd;
endmodule
