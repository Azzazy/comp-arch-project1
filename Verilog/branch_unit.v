`timescale 1ns/1ns
`include "defines.v"

module branch_unit (    
    input [2:0] func3,
    input [31:0]a,
    input [31:0]b, 
	input Branch,
	output reg Branch_con
);
    wire [31:0] add, op_b;
    wire sf, zf, vf, cf;
    
    assign op_b = (~b);
    
    assign {cf, add} = (a + op_b + 1'b1);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
	always @(*) begin
		if(Branch)begin
			if	(func3 == `BR_BEQ)begin
				Branch_con = zf;
			end else if	(func3 == `BR_BNE)begin
				Branch_con = ~zf;
			end else if (func3 == `BR_BLT)begin
				Branch_con = (sf !=vf);
		    end else if (func3 == `BR_BLTU)begin
		        Branch_con = (~cf);
			end else if (func3 == `BR_BGE)begin
				Branch_con = (sf == vf);
			end else if (func3 == `BR_BGEU)begin
			    Branch_con = (cf);
			end else begin
			    Branch_con = 0;
			end
		end else begin
			Branch_con = 0;
		end	
	end
	endmodule
