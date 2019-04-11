`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2019 05:34:05 PM
// Design Name: 
// Module Name: Forward_U
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Forward_U(
    input [4:0] EX_MEM_rd,
    input [4:0] MEM_WB_rd,
    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,
    input EX_MEM_wen,
    input MEM_WB_wen,
    output [1:0] EX_A,
    output [1:0] EX_B,
    output ID_A,
    output ID_B
    );
    assign ID_A = ((IF_ID_rs1 == EX_MEM_rd) && (EX_MEM_wen)&&(EX_MEM_rd !=0));
    assign ID_B = ((IF_ID_rs2 == EX_MEM_rd) && (EX_MEM_wen)&&(EX_MEM_rd !=0));
    assign EX_A[0] = (IF_)
    assign EX_B[0] = 
    assign EX_A[1] = 
    assign EX_B[1] = 
    
    
endmodule
