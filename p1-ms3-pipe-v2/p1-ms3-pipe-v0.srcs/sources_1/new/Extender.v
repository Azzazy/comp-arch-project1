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
    input [15:0] Inst_in,
    output reg [31:0] Inst_out
    );
    reg [4:0]rd_d_ext;
    reg [4:0]rs2_d_ext;
    reg [4:0]rs1_d_ext;
    
    always @(*)begin
        rd_d_ext = {{2'b00}, Inst_in[`C_RD_D]};
        rs2_d_ext = {{2'b00}, Inst_in[`C_RS2_D]};
        rs1_d_ext = {{2'b00}, Inst_in[`C_RS1_D]};
        
        case (Inst_in[`C_OP])
            2'b00:
                case(Inst_in[`C_FUNCT3])
                    3'b000: Inst_out = {{2'b00}, Inst_in[10:8], Inst_in[12:11], Inst_in[5], Inst_in[6],{2'b00}, {5'b00010}, {5'b00000}, Inst_in[`C_RD_D], {7'b0010011}};
                    3'b010: Inst_out = {{5'b00000}, Inst_in[5], Inst_in[12:10], Inst_in[6], {2'b0000}, Inst_in[`C_RS1_D], {3'b010}, {2'b00}, Inst_in[`C_RD_D], {7'b0000011}};
                    3'b110: Inst_out = {{5'b00000}, Inst_in[5], Inst_in[12], rs2_d_ext, rs1_d_ext, {3'b010}, Inst_in[11:10], Inst_in[6], {2'b00}, {7'b0100011}};
                endcase
            2'b01:
                case(Inst_in[`C_FUNCT3])
                    3'b000:
                        if(Inst_in[`C_RD_RS1] == 5'b00000)begin
                            Inst_out = 32'b00000000000000000000000000010011;
                        end else begin
                            Inst_out = {{6'b000000}, Inst_in[12], Inst_in[6:2], Inst_in[`C_RD_RS1], {3'b000}, Inst_in[`C_RD_RS1], {7'b0010011}};
                        end
                    3'b001: Inst_out = {{1'b0}, Inst_in[8], Inst_in[10:9], Inst_in[6], Inst_in[7], Inst_in[2], Inst_in[11], Inst_in[5:3], Inst_in[12], {8'b00000000}, {5'b00001}, {7'b1101111}};
                    3'b010: Inst_out = {{6{Inst_in[12]}}, Inst_in[12], Inst_in[6:2], {5'b00000}, {3'b000}, Inst_in[`C_RD_RS1], {7'b0010011}};
                    3'b011: 
                        if(Inst_in[`C_RD_RS1]==5'b00010)begin
                            Inst_out = {{3{Inst_in[12]}}, Inst_in[4], Inst_in[3], Inst_in[5], Inst_in[2], Inst_in[6], {4'b0000}, Inst_in[`C_RD_RS1], {3'b000}, Inst_in[`C_RD_RS1], {7'b0010011}};
                        end else if(Inst_in[`C_RD_RS1]!=0) begin
                            Inst_out = {{14'b00000000000000}, Inst_in[12], Inst_in[6:2], Inst_in[`C_RD_RS1], 7'b0110111};
                        end
                endcase
           // 2'b10:
            default: Inst_out = 0;
        endcase
    
    
    end
endmodule
