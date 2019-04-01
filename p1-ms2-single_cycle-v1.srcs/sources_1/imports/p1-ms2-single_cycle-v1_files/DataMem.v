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
            mem[0]<=8'd17;
            mem[1]<=0;
            mem[2]<=0;
            mem[3]<=0;
            mem[4]<=8'd9;
            mem[5]<=0;
            mem[6]<=0;
            mem[7]<=0;
            mem[8]<=8'd25;
            mem[9]<=0;
            mem[10]<=0;
            mem[11]<=0;
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

