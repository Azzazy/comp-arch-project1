// file: InstMem.v
// author: @cherifsalama

`timescale 1ns/1ns

module InstMem (
    input rst, 
    input [7:0] addr, 
    output [31:0] data_out
);

    reg [31:0] mem [0:255];
    
    assign  data_out = mem[addr];
    
    always @(posedge rst)
    begin
        mem[0]=32'h00000000;
        mem[1]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
        mem[2]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
        mem[3]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
        mem[4]=32'b0000000_00001_00010_110_00100_0110011 ; //or x4, x1, x2
        mem[5]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 2
        mem[6]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2 //should be skipped // if this executed then x3 would = 26 then next x5 = 35
        mem[7]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2//the correct value is 34 to be in x5
        mem[8]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
        mem[9]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
        //mem[9]=32'b0000000_00001_00110_000_00111_0110011 ; //add x7, x6, x1
        mem[10]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
        mem[11]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2 
        mem[12]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
        mem[13]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
        mem[14]={20'd1,12'b001110110111};//LUI x7, 1
//        mem[14]={12'd3,5'd1,3'd0,5'd10,7'b1100111};//JALR x10, 3(x1)
        mem[15]={25'd0,7'b1110011};//ECALL

    end
    
endmodule


