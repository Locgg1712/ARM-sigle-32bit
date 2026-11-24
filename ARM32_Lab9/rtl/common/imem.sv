module imem #(parameter MEMFILE = "program/memfile.dat") (
    input logic [31:0] a,
    output logic [31:0] rd
);
    logic [31:0] RAM [0:63];
    logic in_range;
    initial $readmemh(MEMFILE, RAM);
    assign in_range = (a[31:8] == 0) && (a[1:0] == 0);
    assign rd = in_range ? RAM[a[7:2]] : 32'bx;
endmodule
