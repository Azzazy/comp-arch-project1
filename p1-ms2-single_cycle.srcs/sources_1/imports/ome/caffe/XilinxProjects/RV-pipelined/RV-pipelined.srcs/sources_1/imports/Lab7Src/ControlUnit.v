// file: ControlUnit.v
// author: @cherifsalama

`timescale 1ns/1ns
`include "defines.v"

module ControlUnit (
    input [4:0] opcode,
    output Branch,
    output MemRead,
    output MemToReg,
    output [1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output shamtSrc,
    output reg [1:0]RegWmux2Ctl
);
    
    always @(*) begin
        case (opcode)  
            `OPCODE_AUIPC:   RegWmux2Ctl = 2'b01;
            `OPCODE_JAL:     RegWmux2Ctl = 2'b10;
            `OPCODE_JALR:    RegWmux2Ctl = 2'b10;
             default:        RegWmux2Ctl = 0;
        endcase
    end
    
    assign Branch   =   (opcode[4:2] ==  6)? 1:0;
    assign MemRead  =   (opcode[4:2] ==  0)? 1:0;
    assign MemToReg =   (opcode[4:2] ==  0)? 1:0;
    
    assign ALUOp[1] =   (opcode[4:2] ==  3)? 1:0;
    assign ALUOp[0] =   (opcode[4:2] ==  6)? 1:0;
    assign MemWrite =   (opcode[4:2] ==  2)? 1:0;
    assign ALUSrc   =   ((opcode[4:2]    ==  0)||(opcode[4:2] ==  2)) ?   1 : 0;
    assign RegWrite =   ((opcode[4:2]    ==  0)||(opcode[4:2] ==  3)) ?   1 : 0;
    assign shamtSrc =   opcode[3];
    
endmodule

