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
    input [7:0] addra,
    input [31:0] dina,
    output reg [31:0] douta
    );
    reg [7:0]mem[0:255];
    initial begin
    
        mem[0] = 8'd0;
        mem[1] = 8'd0;
        mem[2] = 8'd0;
        mem[3] = 8'd0;
        //lw x1, 100(x0)
        mem[4]<=8'b10000011;
        mem[5]<=8'b00100000;
        mem[6]<=8'b01000000;
        mem[7]<=8'b00000110;
        
        //lw x2, 104(x0)
        mem[8]<=8'b00000011;
        mem[9]<=8'b00100001;
        mem[10]<=8'b10000000;
        mem[11]<=8'b00000110;
        
        //lw x3, 108(x0)
        mem[12]<=8'b10000011;
        mem[13]<=8'b00100001;
        mem[14]<=8'b11000000;
        mem[15]<=8'b00000110;
        
        //lui x5,8
        mem[16]<=8'hb7;
        mem[17]<=8'h82;
        mem[18]<=8'h00;
        mem[19]<=8'h00;
        
        //auipc x6,8
        mem[20]<=8'h17;
        mem[21]<=8'h83;
        mem[22]<=8'h00;
        mem[23]<=8'h00;
        
        
        //ECALL
        mem[24]<=8'h73;
        mem[25]<=8'h00;
        mem[26]<=8'h00;
        mem[27]<=8'h00;
        
            
        //Data
        mem[100] <= 8'd10;
        mem[101] <= 8'd0;
        mem[102] <= 8'd0;
        mem[103] <= 8'd0;
    
        mem[104] <= 8'd20;
        mem[105] <= 8'd0;
        mem[106] <= 8'd0;
        mem[107] <= 8'd0;
    
        mem[108] <= 8'd30;
        mem[109] <= 8'd0;
        mem[110] <= 8'd0;
        mem[111] <= 8'd0;
        /*
        mem[0]<=8'b00010011;
        mem[1]<=8'b00000000;
        mem[2]<=8'b00000000;
        mem[3]<=8'b00000000;
        mem[4]<=8'b10110111;
        mem[5]<=8'b00010000;
        mem[6]<=8'b00000000;
        mem[7]<=8'b00000000;
        mem[8]<=8'b00100011;
        mem[9]<=8'b00100010;
        mem[10]<=8'b00010000;
        mem[11]<=8'b00000110;
        mem[12]<=8'b00110111;
        mem[13]<=8'b00110001;
        mem[14]<=8'b00000000;
        mem[15]<=8'b00000000;
        mem[16]<=8'b00100011;
        mem[17]<=8'b00100100;
        mem[18]<=8'b00100000;
        mem[19]<=8'b00000110;
        mem[20]<=8'b10000011;
        mem[21]<=8'b00100011;
        mem[22]<=8'b01000000;
        mem[23]<=8'b00000110;
        mem[24]<=8'b00000011;
        mem[25]<=8'b00100100;
        mem[26]<=8'b10000000;
        mem[27]<=8'b00000110;
        mem[28]<=8'b01100011;
        mem[29]<=8'b01011010;
        mem[30]<=8'b01110100;
        mem[31]<=8'b00000000;
        mem[32]<=8'b00010011;
        mem[33]<=8'b00000000;
        mem[34]<=8'b00000000;
        mem[35]<=8'b00000000;
        mem[36]<=8'b00010011;
        mem[37]<=8'b00000000;
        mem[38]<=8'b00000000;
        mem[39]<=8'b00000000;
        mem[40]<=8'b00010011;
        mem[41]<=8'b00000000;
        mem[42]<=8'b00000000;
        mem[43]<=8'b00000000;
        mem[44]<=8'b00010011;
        mem[45]<=8'b00000000;
        mem[46]<=8'b00000000;
        mem[47]<=8'b00000000;
        mem[48]<=8'b01100111;
        mem[49]<=8'b00000010;
        mem[50]<=8'b01000010;
        mem[51]<=8'b00000000;
        mem[52]<=8'b00010011;
        mem[53]<=8'b00000101;
        mem[54]<=8'b01000000;
        mem[55]<=8'b00000110;
        mem[56]<=8'b11100011;
        mem[57]<=8'b01001100;
        mem[58]<=8'b01100101;
        mem[59]<=8'b11111110;
    */
    end
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
        end
            douta<={mem[addra+3],mem[addra+2], mem[addra+1], mem[addra]};
    end//always
endmodule


/*
module bram(
    input clk,
    input rst,
    input wena,
    input ba,
    input ha,
    input ua,
    input [7:0] addra,
    input [31:0] dina,
    output reg [31:0] douta
    );
    reg [7:0]mem[0:255];
    initial begin
    mem[0] = 8'd0;
    mem[1] = 8'd0;
    mem[2] = 8'd0;
    mem[3] = 8'd0;
    //lw x1, 100(x0)
    mem[4]<=8'b10000011;
    mem[5]<=8'b00100000;
    mem[6]<=8'b01000000;
    mem[7]<=8'b00000110;
    
    //lw x2, 104(x0)
    mem[8]<=8'b00000011;
    mem[9]<=8'b00100001;
    mem[10]<=8'b10000000;
    mem[11]<=8'b00000110;
    
    //lw x3, 108(x0)
    mem[12]<=8'b10000011;
    mem[13]<=8'b00100001;
    mem[14]<=8'b11000000;
    mem[15]<=8'b00000110;
    
    //lui x5,8
    mem[16]<=8'hb7;
    mem[17]<=8'h82;
    mem[18]<=8'h00;
    mem[19]<=8'h00;
    
    //auipc x6,8
    mem[20]<=8'h17;
    mem[21]<=8'h83;
    mem[22]<=8'h00;
    mem[23]<=8'h00;
    
    
    //ECALL
    mem[24]<=8'h73;
    mem[25]<=8'h00;
    mem[26]<=8'h00;
    mem[27]<=8'h00;
    
    
    
    
    mem[28]<=8'b10110011;
    mem[29]<=8'b00000011;
    mem[30]<=8'b00000011;
    mem[31]<=8'b00000000;
    mem[32]<=8'b01100011;
    mem[33]<=8'b10000100;
    mem[34]<=8'b01100011;
    mem[35]<=8'b00000000;
    mem[36]<=8'b00110011;
    mem[37]<=8'b11100100;
    mem[38]<=8'b01000011;
    mem[39]<=8'b00000000;
    mem[40]<=8'b00110011;
    mem[41]<=8'b10000100;
    mem[42]<=8'b01000011;
    mem[43]<=8'b01000000;
    mem[44]<=8'b10010011;
    mem[45]<=8'b11110100;
    mem[46]<=8'b10000011;
    mem[47]<=8'b00000000;
    mem[48]<=8'b11101111;
    mem[49]<=8'b00000101;
    mem[50]<=8'b10000000;
    mem[51]<=8'b00000000;
    mem[52]<=8'b00110011;
    mem[53]<=8'b11010101;
    mem[54]<=8'b00110011;
    mem[55]<=8'b01000000;
    mem[56]<=8'b00010111;
    mem[57]<=8'b00000101;
    mem[58]<=8'b00000011;
    mem[59]<=8'b00000000;
    
    //Data
    mem[100] <= 8'd10;
    mem[101] <= 8'd0;
    mem[102] <= 8'd0;
    mem[103] <= 8'd0;

    mem[104] <= 8'd20;
    mem[105] <= 8'd0;
    mem[106] <= 8'd0;
    mem[107] <= 8'd0;

    mem[108] <= 8'd30;
    mem[109] <= 8'd0;
    mem[110] <= 8'd0;
    mem[111] <= 8'd0;
    
    end
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
        end
            douta<={mem[addra+3],mem[addra+2], mem[addra+1], mem[addra]};
    end//always
endmodule*/