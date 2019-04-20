module DeMux1_2 (
    sel,
    in,
    out1,
    out2
);
    parameter N=1;
    output [N-1:0] out1, out2;
    input [N-1:0] in;
    input sel;
    assign out1 = ~sel?in:0;
    assign out2 = sel?in:0;
endmodule