`timescale 1ns/1ns
`include "defines.v"

module branch_unit (    
    input [2:0] func3, 
	input Branch, zf, sf, vf, cf,
	output reg Branch_con
);
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
