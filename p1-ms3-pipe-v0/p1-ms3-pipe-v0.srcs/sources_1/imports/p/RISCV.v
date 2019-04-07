// file: RISCV.v
// author: @cherifsalama

`timescale 1ns/1ns
`include "defines.v"


module RISCV (
    input               clk, 
    input               rst, 
    input [1:0]         ledSel, 
    input [3:0]         ssdSel,
    output reg [15:0]   leds, 
    output reg [12:0]   ssd
);
//PIPELINE REGISTER WIRES
   wire [31:0] IF_ID_PC, IF_ID_Inst, 
        ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, 
        EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, 
        MEM_WB_Mem_out, MEM_WB_ALU_out;
     wire [7:0] ID_EX_Ctrl;
    wire [4:0] EX_MEM_Ctrl;
    wire [1:0] MEM_WB_Ctrl;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd;
    
 //PIPELINE REGISTER WIRES END
    wire [31:0] PC_out, PCAdder_out, BranchAdder_out, PC_in, 
        RegR1, RegR2, RegW, ImmGen_out, Shift_out, ALUSrcMux_out, 
        ALU_out, Mem_out, Inst, regWSrcMuxOut, Rg1_zero, offset_pc_in1;
    wire branch_jalr,Branch, MemRead, MemToReg, MemWrite,
         ALUSrc, RegWrite, Zero, Branch_con,sf,vf, cf,
         B_JALR,l_zero,unsign,by,half,halt, branch_jal;
    wire [4:0] rs1_src;
    wire [1:0] ALUOp, PCSrc, RegWmux2Ctl;
    wire [3:0] ALUSel;
    wire shamtSrc;
    wire [31:0] shamt;
    wire [31:0] aluin1, aluin2;
    assign PCSrc = branch_jalr | Branch_con |branch_jal;
    
    //PIPELINE REGISTERS
    RegWLoad #(64) IF_ID (clk,rst,1'b1,
                            {PC_out,Inst},
                            {IF_ID_PC,IF_ID_Inst}
                            );
   /* RegWLoad #(155) ID_EX (clk,rst,1'b1,
                            {RegWrite,MemToReg,Branch,MemRead,MemWrite,ALUOp,ALUSrc,
                                IF_ID_PC,RegR1,RegR2,ImmGen_out,
                                IF_ID_Inst[30],IF_ID_Inst[14:12],
                                IF_ID_Inst[19:15],IF_ID_Inst[24:20],IF_ID_Inst[11:7]},
                            {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm,
                                ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd}
                            );*/
    RegWLoad #(124)  ID_EX   (clk, rst, 1'b1,
                                {MemRead, MemToReg, MemWrite, RegWrite, by, half, unsign,shamtSrc,
                                 IF_ID_Inst[`IR_rs1], IF_ID_Inst[`IR_rs2], IF_ID_Inst[`IR_rd], shamt[4:0], 
                                 RegR1, RegR2, ImmGen_out}, 
                                 {ID_EX_Ctrl, ID_EX_rs1, ID_EX_rs2, ID_EX_rd, ID_EX_shamt, ID_EX_RegR1, ID_EX_RegR2, ID_EX_ImmGen});//needs to be fixed
                                 //add branch adder ouput for auipc and offset pc output for jal and jalr
                                 
    RegWLoad #(107) EX_MEM (clk,rst,1'b1,
                            {ID_EX_Ctrl[7:3],
                                BranchAdder_out,Zero,ALU_out,
                                ID_EX_RegR2,ID_EX_Rd},
                            {EX_MEM_Ctrl,EX_MEM_BranchAddOut,EX_MEM_Zero,EX_MEM_ALU_out,
                                EX_MEM_RegR2, EX_MEM_Rd}
                            );
    RegWLoad #(71) MEM_WB (clk,rst,1'b1,
                            {EX_MEM_Ctrl[4:3],
                                Mem_out,EX_MEM_ALU_out,EX_MEM_Rd},
                            {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd}
                            );
    
    //PIPELINE REGISTERS END
    //IF STAGE
    RegWLoad PC(clk,rst,~halt,PC_in,PC_out); 
    InstMem imem(rst,PC_out[9:2],Inst);
    RippleAdder IncPC(PC_out,4,1'b0,PCAdder_out,);//move to IF stage
    Mux2_1 #(32) pcSrcMux(.sel(PCSrc),.in1(PCAdder_out),.in2(BranchAdder_out), .out(PC_in));//changed to mux2

    //IF STAGE END
    //ID STAGE
    branch_unit BU(.a(RegR1), .b(RegR2), .func3(IF_ID_Inst[14:12]), .Branch(Branch), .Branch_con(Branch_con));
    RippleAdder OffsetPC(.a(offset_pc_in1),.b(ImmGen_out), .ci(0), .s(BranchAdder_out));//move to ID stage - add a mini alu to generate the branch signals
    Mux2_1 #(32) OffsetPCMux(.sel(branch_jalr), .in1(IF_ID_PC),.in2(RegR1), .out(offset_pc_in1));//to accomodate for jalr in ID stage
    Mux2_1 #(5) rs1SrcMux(.sel(l_zero), . in1(IF_ID_Inst[`IR_rs1]), .in2(0), .out(rs1_src));//if lui use x0 for rs1
 

    rv32_ImmGen immgen(.IR(IF_ID_Inst), .Imm(ImmGen_out));
    ControlUnit cu(.fun3(IF_ID_Inst[`IR_funct3]), .opcode(IF_ID_Inst[6:2]),.Branch(Branch),.MemRead(MemRead),.MemToReg(MemToReg)
        ,.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.shamtSrc(shamtSrc), .by(by), .half(half),
		.unsign(unsign),.l_zero(l_zero), .Branch_JALR(branch_jalr), .Branch_JAL(branch_jal), .RegWmux2Ctl(RegWmux2Ctl), .halt(halt));
 
    RegFile rf(.clk(~clk),.rst(rst),.WriteEn(RegWrite),
        .rs1(rs1_src),.rs2(Inst[24:20]),.rd(Inst[11:7]),
        .write_data(RegW),.read_data1(RegR1),.read_data2(RegR2));//RegW, Rd and WriteEn from pipeline MEM/WB
    //ID STAGE END  
    //EX STAGE
    Mux2_1 #(32) shamtMux(.sel(shamtSrc), .in1(RegR2), .in2(ImmGen_out), .out(shamt));//add shamt to pipe
    Mux2_1 #(32) aluSrcBMux(ALUSrc,RegR2,ImmGen_out,ALUSrcMux_out);//add multiplexers for load-use hazards rs1 and rs2.
    ALUControl acu(.ALUOp(ALUOp),.func3(Inst[14:12]),.func7(Inst[30]),.sel(ALUSel));
    prv32_ALU alu(.a(RegR1), .b(ALUSrcMux_out), .shamt(shamt[4:0]), .r(ALU_out),
        .cf(cf), .zf(Zero), .vf(vf), .sf(sf), .alufn(ALUSel));
   
    //EX STAGE END
    //MEM STAGE
    DataMem dmem(clk,rst,MemRead,MemWrite,by,half,unsign,ALU_out[7:0],RegR2,Mem_out);//fix address width
    Mux2_1 #(32) regWSrcMux(MemToReg,ALU_out,Mem_out,regWSrcMuxOut);
    Mux4_1 #(32) regWsrcMux1(.sel(RegWmux2Ctl), .in1(regWSrcMuxOut), .in2(BranchAdder_out), .in3(PCAdder_out), .in4(0), .out(RegW));//don't forget to pass addr. in pipeline
    
    
    always @(*) begin
        case(ledSel)
            0: leds <= Inst[15:0];
            1: leds <= Inst[31:16];
            2: leds <= {l_zero,Branch_con, MemRead, MemToReg, ALUOp, MemWrite, 
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
            12: ssd <= rs1_src;
            default: ssd <= 0;
        endcase
    end
endmodule

