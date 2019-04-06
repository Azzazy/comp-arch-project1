`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2019 08:33:47 PM
// Design Name: 
// Module Name: single_memory
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


module single_memory(
    input clk,
    input rst,
    input wen,
    input b,
    input h,
    input u,
    input [9:0] addr,
    input [31:0] din,
    output reg [31:0] dout
    );
    wire [31:0]dout_m;
    bram mymem(.clk(clk), .rst(rst), .wena(wen), .ba(b), .ha(h), .ua(u), .addra(addr), .dina(din), .douta(dout_m));
    always @ (*) begin
    if(u)begin
        if(b)begin
            dout<={24'h000000,dout_m[7:0]};
        end else if(h)begin
            dout<={16'h0000, dout_m[15:0]};
        end else begin
            dout<=dout_m;
        end
        
    end else if(!u)begin
        if(b)begin
            dout<={{24{dout_m[7]}}, dout_m[7:0]};
        end else if(h)begin
            dout<={{16{dout_m[15]}}, dout_m[15:0]};
        end else begin
            dout<=dout_m;
        end
    end
    end
endmodule
