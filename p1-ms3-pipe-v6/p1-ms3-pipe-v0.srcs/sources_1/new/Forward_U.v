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
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    input EX_MEM_wen,
    input MEM_WB_wen,
    input EX_MEM_memtoreg,
    input MEM_WB_memtoreg,
    input branch,
    output EX_A,
    output EX_B,
    output [1:0]ID_A,
    output [1:0]ID_B,
    output stall
    );

    assign ID_A[0] = ((IF_ID_rs1 == EX_MEM_rd) && (EX_MEM_wen)&&(EX_MEM_rd !=0) && (!EX_MEM_memtoreg));
    assign ID_A[1] = ((IF_ID_rs1 == MEM_WB_rd) && (MEM_WB_memtoreg) && (MEM_WB_rd != 0) && (MEM_WB_wen));
    
    assign ID_B[0] = ((IF_ID_rs2 == EX_MEM_rd) && (EX_MEM_wen)&&(EX_MEM_rd !=0)) && (!EX_MEM_memtoreg);
    assign ID_B[1] = ((IF_ID_rs1 == MEM_WB_rd) && (MEM_WB_memtoreg) && (MEM_WB_rd != 0) && (MEM_WB_wen));
    
    assign EX_A = ((ID_EX_rs1 == MEM_WB_rd) && (MEM_WB_wen) && (MEM_WB_rd !=0));
    assign EX_B = ((ID_EX_rs2 == MEM_WB_rd) && (MEM_WB_wen) && (MEM_WB_rd !=0));
    
    assign stall = (((IF_ID_rs1 == EX_MEM_rd)||(IF_ID_rs2 == EX_MEM_rd)) && (EX_MEM_wen) && (EX_MEM_rd !=0) && (EX_MEM_memtoreg));
endmodule
