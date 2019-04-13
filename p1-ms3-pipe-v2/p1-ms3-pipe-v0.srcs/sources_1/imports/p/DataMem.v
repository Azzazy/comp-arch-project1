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
always @(posedge rst or posedge clk) begin
    if (rst) begin
       mem[0]<=8'b00010011;
mem[1]<=8'b00000000;
mem[2]<=8'b00000000;
mem[3]<=8'b00000000;
mem[4]<=8'b10110111;
mem[5]<=8'b00010000;
mem[6]<=8'b00000000;
mem[7]<=8'b00000000;
mem[8]<=8'b00010011;
mem[9]<=8'b00000001;
mem[10]<=8'b00010000;
mem[11]<=8'b00000000;
mem[12]<=8'b10110011;
mem[13]<=8'b00000001;
mem[14]<=8'b00100001;
mem[15]<=8'b00000000;
mem[16]<=8'b00010011;
mem[17]<=8'b00000010;
mem[18]<=8'b01000000;
mem[19]<=8'b00000000;
mem[20]<=8'b10010011;
mem[21]<=8'b00000010;
mem[22]<=8'b10000000;
mem[23]<=8'b00000000;
mem[24]<=8'b00010011;
mem[25]<=8'b00000011;
mem[26]<=8'b00000000;
mem[27]<=8'b00000001;
mem[28]<=8'b10110011;
mem[29]<=8'b01100011;
mem[30]<=8'b01010011;
mem[31]<=8'b00000000;
mem[32]<=8'b00110011;
mem[33]<=8'b01100100;
mem[34]<=8'b00110010;
mem[35]<=8'b00000000;
mem[36]<=8'b00110011;
mem[37]<=8'b01100100;
mem[38]<=8'b01110100;
mem[39]<=8'b00000000;
mem[40]<=8'b00010011;
mem[41]<=8'b01100100;
mem[42]<=8'b00010100;
mem[43]<=8'b00000000;
mem[44]<=8'b10010011;
mem[45]<=8'b00000011;
mem[46]<=8'b11100000;
mem[47]<=8'b00000001;
mem[48]<=8'b01100011;
mem[49]<=8'b11001010;
mem[50]<=8'b10000011;
mem[51]<=8'b00000000;
mem[52]<=8'b00010011;
mem[53]<=8'b00000000;
mem[54]<=8'b00000000;
mem[55]<=8'b00000000;
mem[56]<=8'b00010011;
mem[57]<=8'b00000000;
mem[58]<=8'b00000000;
mem[59]<=8'b00000000;
mem[60]<=8'b00010011;
mem[61]<=8'b00000000;
mem[62]<=8'b00000000;
mem[63]<=8'b00000000;
mem[64]<=8'b00010011;
mem[65]<=8'b00000000;
mem[66]<=8'b00000000;
mem[67]<=8'b00000000;
mem[68]<=8'b01100111;
mem[69]<=8'b00000010;
mem[70]<=8'b01000010;
mem[71]<=8'b00000000;
mem[72]<=8'b00010011;
mem[73]<=8'b00000101;
mem[74]<=8'b01000000;
mem[75]<=8'b00000110;
mem[76]<=8'b11100011;
mem[77]<=8'b01001100;
mem[78]<=8'b01100101;
mem[79]<=8'b11111110;
        mem[100]<=8'd17;
        mem[101]<=8'b00000000;
        mem[102]<=8'b00000000;
        mem[103]<=8'b00000000;
        mem[104]<=8'd9;
        mem[105]<=8'b00000000;
        mem[106]<=8'b00000000;
        mem[107]<=8'b00000000;
        mem[108]<=8'd25;
        mem[109]<=8'b00000000;
        mem[110]<=8'b00000000;
        mem[111]<=8'b00000000;
    end else if(clk)begin
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

