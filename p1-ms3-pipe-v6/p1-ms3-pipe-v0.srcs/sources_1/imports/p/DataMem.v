// file: DataMem.v
// author: @cherifsalama

`timescale 1ns/1ns

module DataMem (
    input clk, 
    input rst, 
    input MemRead, 
    input MemWrite,
    input by,
    input half,
    input unsign, 
    input [7:0] addr, 
    input [31:0] data_in, 
    output reg [31:0] data_out
);

    reg [7:0] mem [0:255];
    always @(posedge rst or posedge clk) 
    begin
        if(rst==1) begin
            mem[0]<=8'b10010011;
            mem[1]<=8'b00000000;
            mem[2]<=8'b10100000;
            mem[3]<=8'b00000000;
            mem[4]<=8'b00010011;
            mem[5]<=8'b00000001;
            mem[6]<=8'b01000000;
            mem[7]<=8'b00000001;
            mem[8]<=8'b10010011;
            mem[9]<=8'b00000001;
            mem[10]<=8'b11100000;
            mem[11]<=8'b00000001;
            mem[12]<=8'b00110011;
            mem[13]<=8'b10000010;
            mem[14]<=8'b00100000;
            mem[15]<=8'b00000000;
            mem[16]<=8'b10110011;
            mem[17]<=8'b10000010;
            mem[18]<=8'b01000001;
            mem[19]<=8'b01000000;
        end
        else begin
            if (MemWrite)begin
                if(by)
                    begin
                        mem[addr]   =   data_in[7:0];
                    end                             
                else if(half)
                    begin
                        mem[addr]   =   data_in[7:0];
                        mem[addr+1] =   data_in[15:8];
                    end
                else
                    begin
                        mem[addr]   =   data_in[7:0];
                        mem[addr+1] =   data_in[15:8];
                        mem[addr+2] =   data_in[23:16];
                        mem[addr+3] =   data_in[31:24];
                    end
            end
        end
    end
    always @(*) begin
        if(MemRead)begin
            if(by & unsign) begin//shouldn't be unsigned???
                data_out = {24'h000000,mem[addr][7:0]};
            end else if(by & !unsign) begin
                data_out = {{24{mem[addr][7]}},mem[addr][7:0]};
            end else if(half & unsign) begin
                data_out = {16'h0000,mem[addr+1],mem[addr]};
            end else if(half & !unsign) begin
                data_out = {{16{mem[addr+1][7]}},mem[addr+1],mem[addr]};
            end else begin
            data_out = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
            end
        end
    end
endmodule

