`timescale 1ns/1ns

module branch_unit (    
    input [3:0] func3, 
	input Branch, zf, sf, vf, cf,
	output reg Branch_con
);
	always @(*) begin
		if(Branch)begin
			if		(func3 == 0)begin
				Branch_con = zf;
			end else if	(func3 == 1)begin
				Branch_con = ~zf;
			end else if (func3 == 4)begin
				Branch_con = (sf !=vf);
		    end else if (func3 ==6)begin
		        Branch_con = (~cf);
			end else if (func3 == 5)begin
				Branch_con = (sf == vf);
			end else if (func3 == 7)begin
			    Branch_con = (cf);
			end
		end else begin
			Branch_con = 0;
		end	
	end
	endmodule
