`timescale 1ns / 1ps
`include "defines.v"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2019 03:44:22 PM
// Design Name: 
// Module Name: Extender
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


module Extender(
    input [31:0] instin,
    output reg [31:0] Inst_out
    );
    reg [4:0]rd_d_ext;
    reg [4:0]rs2_d_ext;
    reg [4:0]rs1_d_ext;
    
    always @(*)begin
        rd_d_ext = {{2'b00}, instin[`C_RD_D]};
        rs2_d_ext = {{2'b00}, instin[`C_RS2_D]};
        rs1_d_ext = {{2'b00}, instin[`C_RS1_D]};
        
        case (instin[`C_OP])
            2'b00:
                case(instin[`C_FUNCT3])
                    3'b000: Inst_out = {{2'b00}, instin[10:7], instin[12:11], instin[5], instin[6],{2'b00}, {5'b00010}, {5'b00000}, instin[`C_RD_D], {7'b0010011}};//c.addi4spn
                    3'b010: Inst_out = {{5'b00000}, instin[5], instin[12:10], instin[6], {2'b0000}, instin[`C_RS1_D], {3'b010}, {2'b00}, instin[`C_RD_D], {7'b0000011}};//c.lw
                    3'b110: Inst_out = {{5'b00000}, instin[5], instin[12], rs2_d_ext, rs1_d_ext, {3'b010}, instin[11:10], instin[6], {2'b00}, {7'b0100011}};//c.sw
                    default: Inst_out = {12'h001, 5'b00000, 3'b000, 5'b00000, 7'b1110011};//Ebreak in case of an unsupported compressed instruction
                endcase
            2'b01:
                case(instin[`C_FUNCT3])
                    3'b000:
                        if(instin[`C_RD_RS1] == 5'b00000)begin
                            Inst_out = 32'b00000000000000000000000000010011;//C.NOP
                        end else if({instin[12], instin[6:2]} != 6'b000000) begin
                            Inst_out = {{6{instin[12]}}, instin[12], instin[6:2], instin[`C_RD_RS1], {3'b000}, instin[`C_RD_RS1], {7'b0010011}};//C.ADDI
                        end
                    3'b001: Inst_out = {{instin[12]}, instin[8], instin[10:9], instin[6], instin[7], instin[2], instin[11], instin[5:3], instin[12], {8{instin[12]}}, {5'b00001}, {7'b1101111}};//C.JAL
                    3'b010: Inst_out = {{6{instin[12]}}, instin[12], instin[6:2], {5'b00000}, {3'b000}, instin[`C_RD_RS1], {7'b0010011}};//C.LI
                    3'b011: 
                        if(instin[`C_RD_RS1]==5'b00010)begin
                            Inst_out = {{3{instin[12]}}, instin[4], instin[3], instin[5], instin[2], instin[6], {4'b0000}, instin[`C_RD_RS1], {3'b000}, instin[`C_RD_RS1], {7'b0010011}};//C.ADDI16SP
                        end else if((instin[`C_RD_RS1]!= 5'b00000) && (instin[`C_RD_RS1] != 5'b00010)) begin
                            Inst_out = {{14{instin[12]}}, instin[12], instin[6:2], instin[`C_RD_RS1], 7'b0110111};//C.LUI
                        end
                    3'b100:
                        if(instin[11:10] == 2'b00)begin
                            Inst_out = {7'b0000000, instin[6:2], 2'b00, instin[`C_RS1_D], 3'b101, 2'b00, instin[`C_RS1_D], 7'b0010011};//C.SRLI //shamt[5] in the compressed inst. is neglected
                        end else if(instin[11:10] == 2'b01) begin
                            Inst_out = {7'b0100000, instin[6:2], 2'b00, instin[9:7], 3'b101, 2'b00, instin[9:7],7'b0010011};//C.SRAI
                        end else if(instin[11:10] == 2'b10)begin
                            Inst_out = {{6{instin[12]}}, instin[12], instin[6:2], 2'b00, instin[9:7], 3'b111, 2'b00, instin[9:7], 7'b0010011};//C.ANDI
                        end else if(instin[11:10] == 2'b11)begin
                            if(instin[6:5] == 2'b00)begin
                                Inst_out = {7'b0100000, 2'b00, instin[4:2], 2'b00, instin[9:7], 3'b000, 2'b00, instin[9:7], 7'b0110011};//C.SUB
                            end else if(instin[6:5] == 2'b01)begin
                                Inst_out = {7'b0000000, 2'b00, instin[4:2], 2'b00, instin[9:7], 3'b100, 2'b00, instin[9:7], 7'b0110011};//C.XOR
                            end else if(instin[6:5] == 2'b10)begin
                                Inst_out = {7'b0000000, 2'b00, instin[4:2], 2'b00, instin[9:7], 3'b110, 2'b00, instin[9:7], 7'b0110011};//C.OR
                            end else if(instin[6:5] == 2'b11)begin
                                Inst_out = {7'b0000000, 2'b00, instin[4:2], 2'b00, instin[9:7], 3'b111, 2'b00, instin[9:7], 7'b0110011};//C.AND
                            end
                        end
                    3'b101:
                        Inst_out = {instin[12], instin[8], instin[10:9], instin[6], instin[7], instin[2], instin[11], instin[5:3], instin[12], {8{instin[12]}}, 5'b00000, 7'b1101111};//C.J
                    3'b110:
                        Inst_out = {instin[12], {2{instin[12]}}, instin[12], instin[6:5], instin[2], 5'b00000, 2'b00, instin[9:7], 3'b000, instin[11:10], instin[4:3], instin[12], 7'b1100011};//C.BEQZ
                    3'b111:
                        Inst_out = {instin[12], {2{instin[12]}}, instin[12], instin[6:5], instin[2], 5'b00000, 2'b00, instin[9:7], 3'b001, instin[11:10], instin[4:3], instin[12], 7'b1100011};//C.BNEZ
                    default: Inst_out = {12'h001, 5'b00000, 3'b000, 5'b00000, 7'b1110011};//Ebreak in case of an unsupported compressed instruction
                endcase
            2'b10:
                case(instin[`C_FUNCT3])
                    3'b000:
                       Inst_out={7'b00000000,instin[6:2],instin[11:7],3'b001,instin[11:7],7'b0010011}; ///C.SLLI
                    3'b010:
                       Inst_out={4'b0000,instin[3:2],instin[12],instin[6:4],10'b0000010010,instin[11:7],7'b0000011}; //C.LWSP
                    3'b100:
                        if((!instin[12]) && (instin[6:2]==5'b00000)) begin
                            Inst_out={12'b000000000000,instin[11:7],15'b000000001100111}; //C.JR                              
                        end
                        else if(!instin[12] && (instin[6:2]!=5'b00000)) begin
                            Inst_out={7'b0000000,instin[6:2], 8'b00000000,instin[11:7],7'b0110011}; //C.MV
                        end
                        else if((instin[12]) && (instin[6:2]==0) && (instin[11:7]==0)) begin 
                            Inst_out=32'b00000000000100000000000001110011;                   //EBREAK        
                        end 
                        else if((instin[12]) && (instin[6:2]==5'b00000) && (instin[11:7]!=5'b00000)) begin
                            Inst_out={12'b000000000000,instin[11:7],15'b000000011100111}; //C.JALR;
                        end
                        else if(instin[12] && (instin[6:2]!=0) && (instin[11:7]!=0)) begin
                            Inst_out={7'b0000000,instin[6:2],instin[11:7],3'b000,instin[11:7],7'b0110011}; //C.ADD;
                        end
                   3'b110:
                        Inst_out={4'b0000,instin[8:7], instin[12],instin[6:2],8'b00010010,instin[11:9],9'b000100011}; //C.SWSP
                   default: Inst_out = {12'h001, 5'b00000, 3'b000, 5'b00000, 7'b1110011};//Ebreak in case of an unsupported compressed instruction
                endcase
            2'b11: Inst_out = instin;
        endcase
    
    
    end
endmodule
