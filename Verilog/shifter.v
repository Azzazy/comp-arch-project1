`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2019 01:52:02 AM
// Design Name: 
// Module Name: shifter
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


module shifter(
    input [31:0] a,
    input [4:0] shamt,
    input [1:0] type,
    output reg [31:0] r
    );
    
    always @ * begin
    r = 0;
    case(type)
    0   :   r = a   <<  shamt;
    1   :   r = a   >>  shamt;
    2   :   r = a  >>>  shamt;
    default: r = 0;
    
    endcase
    end
endmodule
