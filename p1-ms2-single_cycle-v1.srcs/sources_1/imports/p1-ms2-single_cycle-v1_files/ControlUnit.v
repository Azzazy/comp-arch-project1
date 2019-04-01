// file: ControlUnit.v
// author: @cherifsalama

`timescale 1ns/1ns
`include "defines.v"

module ControlUnit (
    input [2:0] fun3,
    input [4:0] opcode,
    output reg Branch,
    output reg MemRead,
    output reg MemToReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg shamtSrc,
    output reg by,
    output reg half,
    output reg unsign,
	output reg l_zero,
	output reg Branch_JALR,
    output reg [1:0]RegWmux2Ctl
);
    
    always @(*) begin
        case (opcode)  //to control the source of the data written to the register file
            `OPCODE_AUIPC:   RegWmux2Ctl = 2'b01;
            `OPCODE_JAL:     RegWmux2Ctl = 2'b10;
            `OPCODE_JALR:    RegWmux2Ctl = 2'b10;
             default:        RegWmux2Ctl = 2'b00;
        endcase
        
        if((opcode== `OPCODE_SYSTEM)||(opcode==`OPCODE_FENCE))begin
            Branch_JALR =0;
            Branch   =   0;
            MemRead  =   0;
            MemToReg =   0;    
            ALUOp[1] =   0;
            ALUOp[0] =   0;
            MemWrite =   0;
            ALUSrc   =   0;     
            RegWrite =   0;
            shamtSrc =   0; 					
            by       =   0;
            half     =   0;
            unsign   =   0;
            l_zero	=	 0; 	//LUI: load zero instead of rs1 into the first ALU input
        end else begin
    
            Branch_JALR =(opcode	 ==  `OPCODE_JALR) ?1:0;
            Branch   =   (opcode[4:2] ==  6)? 1:0;//branch, jal and jalr instructions
            MemRead  =   (opcode[4:2] ==  `OPCODE_Load)? 1:0;
            MemToReg =   (opcode ==  `OPCODE_Load)? 1:0;//load instructions 
            case (opcode)  
                `OPCODE_Arith_R:   ALUOp = 0;
                `OPCODE_Arith_I:   ALUOp = 3;
                `OPCODE_Branch:   ALUOp = 2;
                //1: LW, SW, AUIPC,LUI,JAL,JALR
                default:          ALUOp = 1; 
            endcase
            MemWrite =   (opcode[4:2] ==  2)? 1:0;//store instructions
            ALUSrc   =   ((opcode    ==  `OPCODE_Load)|| (opcode == `OPCODE_Store) || (opcode == `OPCODE_Arith_I) || (opcode    ==  `OPCODE_JALR) || (opcode == `OPCODE_LUI)) ?   1 : 0;     
            RegWrite =   ((opcode    ==  `OPCODE_Load) || (opcode ==`OPCODE_Arith_I) || (opcode==`OPCODE_JALR) || (opcode == `OPCODE_JAL) ||(opcode ==  `OPCODE_AUIPC)|| (opcode == `OPCODE_LUI)) ?   1 : 0;
            shamtSrc =   ~opcode[3];//if shamtSrc ==1 --> use immediate as source, else use Rs2
            by       =   ((opcode == `OPCODE_Load) || (opcode == `OPCODE_Store)) && (fun3 == 0 || fun3 == 4);
            half     =   ((opcode == `OPCODE_Load) || (opcode == `OPCODE_Store)) && (fun3 == 1 || fun3 == 5);
            unsign   =   ((opcode == `OPCODE_Load) && (fun3 == 4 || fun3 ==5));//lbu and lhu
            l_zero	=	(opcode	==	`OPCODE_LUI); 	//LUI: load zero instead of rs1 into the first ALU input
        end
	end
	
endmodule

