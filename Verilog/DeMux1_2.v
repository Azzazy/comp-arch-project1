module DeMux1_2 (
    sel,
    in,
    out1,
    out2
);
    parameter N=1;
    output reg [N-1:0] out1, out2;
    input [N-1:0] in;
    input sel;
    always @(*) begin
        if(~sel)out1=in;
        if(sel)out2=in;
    end
endmodule