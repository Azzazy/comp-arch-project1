`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2019 08:32:44 PM
// Design Name: 
// Module Name: DeMux1_2
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


module DeMux1_2 (
    sel,
    in,
    out1,
    out2
);
    parameter N=1;
    output [N-1:0] out1, out2;
    input [N-1:0] in;
    input sel;
    
    assign out1 = (~sel)?in:0;
    assign out2 = (sel)?in:0;
endmodule