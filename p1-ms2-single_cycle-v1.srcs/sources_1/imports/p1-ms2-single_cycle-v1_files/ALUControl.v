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
            0:  if(opcode==1) begin //I-Format
                    if(func3==0) begin
                        sel = 4'b0000;//add
                    end else if(func3==2) begin
                        sel = 4'b1101;//slti
                    end else if(func3==3) begin
                        sel = 4'b1111;//sltiu
                    end else if(func3==4) begin
                        sel = 4'b0111;//xori
                    end else if(func3==6) begin
                        sel = 4'b0100;//ori
                    end else if(func3==7) begin
                        sel = 4'b0101;//andi
                    end else if(func3==1) begin
                        sel =4'b1000;//slli
                    end else if(func3==5 && !func7) begin
                        sel= 4'b1001;//srli
                    end else if(func3==5 && func7) begin
                        sel= 4'b1010;//srai
					end else begin
						sel =4'b0000; //LUI
					end
                end else begin //load-store 
                    sel = 4'b0000;
                end     
            1:  
				if(j)begin
					sel = 4'b0000;	// jumps JAL+JALR
				end else begin
					sel = 4'b0001;  //Branching     
                end 
            2:  
                if((func3==0)&&!func7) begin //R-Format//add
                    sel = 4'b0000;
                end else if ((func3==0)&& (func7))begin
                    sel = 4'b0001;//sub
                end else if(func3==7)begin
                    sel = 4'b0101;//and
                end else if(func3==6)begin
                    sel = 4'b0100;//or
                end else if(func3==4)begin
                    sel = 4'b0111;//xor
                end else if(func3==2)begin
                    sel = 4'b1101;//slt
                end else if(func3==3)begin
                    sel = 4'b1111;//sltu
                end else if((func3==5) && (!func7))begin
                    sel = 4'b1001;//srl
                end else if((func3==5) && (func7))begin
                    sel = 4'b1010;//sra
                end else if(func3==1)begin
                    sel = 4'b1000; //sll
                end else begin
                    sel = 4'b0000;
                end
           default: sel = 4'b0000;        
        endcase
    end   
endmodule
