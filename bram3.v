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
    input wenb,
    input bb,
    input hb,
    input ub,
    input [9:0] addra,
    input [9:0] addrb,
    input [31:0] dina,
    input [31:0] dinb,
    output reg [31:0] douta,
    output reg [31:0] doutb
    );
    reg [7:0]mem[0:1023];
    
    always @ (posedge clk)begin
        if(wena)begin
             if(ba)begin
                mem[addra]<=dina[7:0];
            end else if(ha)begin
                mem[addra]<=dina[7:0];
                mem[addra]<=dina[15:8];
            end else begin
                mem[addra]<=dina[7:0];
                mem[addra]<=dina[15:8];
                mem[addra]<=dina[23:16];
                mem[addra]<=dina[31:24];
            end
        end else if(wenb) begin
                if(bb)begin
                mem[addrb]<=dinb[7:0];
            end else if(hb)begin
                mem[addrb]<=dinb[7:0];
                mem[addrb]<=dinb[15:8];
            end else begin
                mem[addrb]<=dinb[7:0];
                mem[addrb]<=dinb[15:8];
                mem[addrb]<=dinb[23:16];
                mem[addrb]<=dinb[31:24];
            end
        end else begin
            douta<={mem[addra+3],mem[addra+2], mem[addra+1], mem[addra]};
            doutb<={mem[addrb+3],mem[addrb+2], mem[addrb+1], mem[addrb]};

        end
    end//always
endmodule

