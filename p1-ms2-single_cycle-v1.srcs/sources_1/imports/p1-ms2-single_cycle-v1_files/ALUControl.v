`timescale 1ns/1ns
`include "defines.v"

module ALUControl(
    input [1:0] ALUOp,
    input [2:0] func3,
    input func7,
    output reg [3:0] sel
);
    always @(*) 
        case(ALUOp) 
            0:  
                case(func3)
                `F3_SLL:    sel = 4'b1000; //sll
                `F3_SLT:    sel = 4'b1101;//slt
                `F3_SLTU:    sel = 4'b1111;//sltu
                `F3_XOR:    sel = 4'b0111;//xor
                `F3_OR:    sel = 4'b0100;//or
                `F3_AND:    sel = 4'b0101;//and
                `F3_ADD:    sel = func7;//add or sub
                `F3_SRL:    sel = 4'b1001 + func7;//srl or sra
                endcase
                 
            1:  sel = 4'b0000;//add
            2:  sel = 4'b0001;//sub    
            3:
                case(func3)
                    `F3_SLL:    sel = 4'b1000; //sll
                    `F3_SLT:    sel = 4'b1101;//slt
                    `F3_SLTU:    sel = 4'b1111;//sltu
                    `F3_XOR:    sel = 4'b0111;//xor
                    `F3_OR:    sel = 4'b0100;//or
                    `F3_AND:    sel = 4'b0101;//and
                    `F3_ADD:    sel = 4'b0000;//add or sub
                    `F3_SRL:    sel = 4'b1001 + func7;//srl or sra
                endcase
        endcase   
endmodule
