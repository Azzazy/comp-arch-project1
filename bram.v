`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2019 12:50:37 AM
// Design Name: 
// Module Name: bram
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


module bram(
    input clk,
    input rst,
    input wena,
    input ba,
    input ha,
    input ua,
    input [9:0] addra,
    input [31:0] dina,
    output reg [31:0] douta
    );
    reg [7:0]mem[0:1023];
    
    always @ (posedge clk)begin
        if(wena)begin
             if(ba)begin
                mem[addra]<=dina[7:0];
            end else if(ha)begin
                mem[addra]<=dina[7:0];
                mem[addra+1]<=dina[15:8];
            end else begin
                mem[addra]<=dina[7:0];
                mem[addra+1]<=dina[15:8];
                mem[addra+2]<=dina[23:16];
                mem[addra+3]<=dina[31:24];
            end
        end
            douta<={mem[addra+3],mem[addra+2], mem[addra+1], mem[addra]};
    end//always
endmodule
