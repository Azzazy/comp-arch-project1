`timescale 1ns/1ns

module ALUControl(
    input [1:0] ALUOp,
    input [2:0] func3,
    input func7,
    input opcode,
	input j,
    output reg [3:0] sel
);

    always @(*) begin
        case(ALUOp) 
            0:  if(opcode==1) //I-Format
                    if(func3==0)
                        sel = 4'b0000;
                    else if(func3==2)
                        sel = 4'b1101;
                    else if(func3==3)
                        sel = 4'b1111;
                    else if(func3==4)
                        sel = 4'b0111;
                    else if(func3==6)
                        sel = 4'b0100;
                    else if(func3==7)
                        sel = 4'b0101;
                    else if(func3==1)
                        sel =4'b1000;
                    else if(func3==5 & !func7)
                        sel= 4'b1001;
                    else if(func3==5 & func7)
                        sel= 4'b1010;
					else
						sel =4'b0000; //LUI+AUIPC
                 else //load-store 
                    sel = 4'b0000;
                    
            1:  
				if(j)
					sel = 4'b0000;	// jumps JAL+JALR
				else
					sel = 4'b0001;  //Branching     
                   
            2:  
                //if()
                if((func3==0)&&!func7) //R-Format
                    sel = 4'b0000;
                else if (func3==0)
                    sel = 4'b0010;
                else if(func3==7)
                    sel = 4'b0101;
                else if(func3==6)
                    sel = 4'b0100;
                else if(func3==4)
                    sel = 4'b0111;
                else if(func3==2)
                    sel = 4'b1101;
                else if(func3==3)
                    sel = 4'b1111;
                else if(func3==5&&!func7)
                    sel = 4'b1001;
                else if(func3==5&&func7)
                    sel = 4'b1010;
                else if(func3==1)
                    sel = 4'b1000; 
           default: sel = 4'b0000;        
        endcase
    end   
endmodule
/*                      4'b00_00 : r = add;
                        4'b00_01 : r = add;
                        4'b00_11 : r = b;
                        // logic
                        4'b01_00:  r = a | b;
                        4'b01_01:  r = a & b;
                        4'b01_11:  r = a ^ b;
                        // shift
                        4'b10_00:  r=sh;
                        4'b10_01:  r=sh;
                        4'b10_10:  r=sh;
                        // slt & sltu
                        4'b11_01:  r = {31'b0,(sf != vf)}; 
                        4'b11_11:  r = {31'b0,(~cf)}; 
                        assign ALUOp[1] =   (opcode[4:2] ==  3)? 1:0;
                    assign ALUOp[0] =   (opcode[4:2] ==  6)? 1:0;
                     .type(alufn[1:0]) */            