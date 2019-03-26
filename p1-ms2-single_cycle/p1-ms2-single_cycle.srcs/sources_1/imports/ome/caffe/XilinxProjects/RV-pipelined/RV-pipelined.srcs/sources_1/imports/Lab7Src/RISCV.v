// file: RISCV.v
// author: @cherifsalama

`timescale 1ns/1ns

module RISCV (
    input clk, 
    input rst, 
    input [1:0] ledSel, 
    input [3:0] ssdSel,
    output reg [15:0] leds, 
    output reg [12:0] ssd
);

    wire [31:0] PC_out, PCAdder_out, BranchAdder_out, PC_in, 
        RegR1, RegR2, RegW, ImmGen_out, Shift_out, ALUSrcMux_out, 
        ALU_out, Mem_out, Inst;
    wire Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, Zero;
    wire [1:0] ALUOp;
    wire [3:0] ALUSel;
    wire PCSrc, shamtSrc;
    wire [4:0] shamt;
    
    wire [31:0] IF_ID_PC, IF_ID_Inst, 
        ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, 
        EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, 
        MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [7:0] ID_EX_Ctrl;
    wire [4:0] EX_MEM_Ctrl;
    wire [1:0] MEM_WB_Ctrl;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd;
    wire [31:0] aluin1, aluin2;

    RegWLoad PC(clk,rst,1'b1,PC_in,PC_out);

    InstMem imem(rst,PC_out[7:0],Inst);
    RippleAdder IncPC(PC_out,4,1'b0,PCAdder_out,);
    RegFile rf(.clk(~clk),.rst(rst),.WriteEn(RegWrite),
        .rs1(Inst[19:15]),.rs2(Inst[24:20]),.rd(Inst[11:7]),
        .write_data(RegW),.read_data1(RegR1),.read_data2(RegR2));
    
    Mux2_1 shamtMux(.sel(shamtSrc),.in1(ImmGen_out), .in2(RegR2), .out(shamt));
    prv32_ALU alu(.a(RegR1), .b(ALUSrcMux_out), .shamt(shamt), .r(ALU_out),
        .cf(), .zf(Zero), .vf(), .sf(), .alufn(ALUSel));
    rv32_ImmGen immgen(.IR(Inst), .Imm(ImmGen_out));
    Mux2_1 #(32) aluSrcBMux(ALUSrc,RegR2,ImmGen_out,ALUSrcMux_out);
    //ALU a1(ALUSel,aluin1,ALUSrcMux_out,ALU_out,Zero);
    ShiftLeft1 sh(ImmGen_out,Shift_out);
    RippleAdder OffsetPC(PC_out,Shift_out,1'b0,BranchAdder_out,);
    Mux2_1 #(32) pcSrcMux(PCSrc,PCAdder_out,BranchAdder_out,PC_in);
    assign PCSrc = Zero && Branch;
    DataMem dmem(clk,rst,MemRead,MemWrite,ALU_out[7:0],RegR2,Mem_out);
    Mux2_1 #(32) regWSrcMux(MemToReg,ALU_out,Mem_out,RegW);
    ControlUnit cu(Inst[6:4],Branch,MemRead,MemToReg,ALUOp,MemWrite,ALUSrc,RegWrite,shamtSrc);
    ALUControl acu(ALUOp,Inst[14:12],Inst[30],ALUSel);
    
    always @(*) begin
        case(ledSel)
            0: leds <= Inst[15:0];
            1: leds <= Inst[31:16];
            2: leds <= {Branch, MemRead, MemToReg, ALUOp, MemWrite, 
                        ALUSrc, RegWrite, Zero, PCSrc, ALUSel};
            default: leds <= 0;            
        endcase
        
        case(ssdSel)
            0: ssd <= PC_out[12:0];
            1: ssd <= PCAdder_out[12:0]; 
            2: ssd <= BranchAdder_out[12:0]; 
            3: ssd <= PC_in[12:0];
            4: ssd <= RegR1[12:0]; 
            5: ssd <= RegR2[12:0]; 
            6: ssd <= RegW[12:0]; 
            7: ssd <= ImmGen_out[12:0]; 
            8: ssd <= Shift_out[12:0]; 
            9: ssd <= ALUSrcMux_out[12:0]; 
            10: ssd <= ALU_out[12:0]; 
            11: ssd <= Mem_out[12:0];
            default: ssd <= 0;
        endcase
    end
endmodule

