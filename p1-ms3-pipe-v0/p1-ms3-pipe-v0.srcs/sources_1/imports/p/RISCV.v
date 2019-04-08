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
   wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PCAdder_out, ID_EX_ImmGen, ID_EX_RegR1, ID_EX_RegR2, ID_EX_BranchAdder_out, ID_EX_PC, 
   ID_EX_PCAdder_out, EX_MEM_BranchAdder_out, EX_MEM_PCAdder_out, EX_MEM_ALU_out, EX_MEM_RegR2, MEM_WB_RegW;
   wire [12:0]  ID_EX_Ctrl;
   wire [8:0] EX_MEM_Ctrl;
   wire [2:0] ID_EX_func3;
   wire ID_EX_func7, MEM_WB_Ctrl;
   wire [4:0] ID_EX_rd, EX_MEM_rd, MEM_WB_rd;
 //PIPELINE REGISTER WIRES END
    wire [31:0] PC_out, PCAdder_out, BranchAdder_out, PC_in, 
        RegR1, RegR2, RegW, ImmGen_out, Shift_out, ALUSrcMux_out, 
        ALU_out, Mem_out, Inst, regWSrcMuxOut, offset_pc_in1;
    wire branch_jalr,Branch, MemRead, MemToReg, MemWrite,
         ALUSrc, RegWrite, Zero, Branch_con,sf,vf, cf,
         B_JALR,l_zero,unsign,by,half,halt, branch_jal;
    wire [4:0] rs1_src;
    wire [1:0] ALUOp, PCSrc, RegWmux2Ctl;
    wire [3:0] ALUSel;
    wire shamtSrc;
    wire [31:0] shamt;
    assign PCSrc = branch_jalr | Branch_con |branch_jal;
    
    //PIPELINE REGISTERS
    RegWLoad #(96) IF_ID (clk,rst,1'b1,
                            {PC_out,Inst, PCAdder_out},
                            {IF_ID_PC,IF_ID_Inst, IF_ID_PCAdder_out}
                            );

    RegWLoad #(182)  ID_EX   (clk, rst, 1'b1,
                                {IF_ID_Inst[30], IF_ID_Inst[`IR_funct3], shamtSrc, ALUSrc, ALUOp, MemRead, MemWrite, by, half, unsign,
                                    MemToReg, RegWmux2Ctl, RegWrite, IF_ID_Inst[`IR_rd], ImmGen_out, RegR1, RegR2,
                                    BranchAdder_out, IF_ID_PCAdder_out}, 
                                 {ID_EX_func7, ID_EX_func3, ID_EX_Ctrl, ID_EX_rd, ID_EX_ImmGen, ID_EX_RegR1, ID_EX_RegR2, 
                                 ID_EX_BranchAdder_out, ID_EX_PCAdder_out});//needs to be fixed
                                 //add branch adder ouput for auipc and offset pc output for jal and jalr
                                 
    RegWLoad #(142) EX_MEM (clk,rst,1'b1,
                            {ID_EX_Ctrl[8:0], ID_EX_rd, ID_EX_BranchAdder_out, ID_EX_PCAdder_out, ALU_out, ID_EX_RegR2},
                            {EX_MEM_Ctrl, EX_MEM_rd, EX_MEM_BranchAdder_out, EX_MEM_PCAdder_out, EX_MEM_ALU_out, EX_MEM_RegR2}
                            );
    RegWLoad #(38) MEM_WB (clk,rst,1'b1,
                            {EX_MEM_Ctrl[0], EX_MEM_rd, RegW},
                            {MEM_WB_Ctrl,MEM_WB_rd, MEM_WB_RegW}
                            );
    
    //PIPELINE REGISTERS END
    //IF STAGE
    RegWLoad PC(clk,rst,~halt,PC_in,PC_out);//change the updating of the PC
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
 
    RegFile rf(.clk(~clk),.rst(rst),.WriteEn(MEM_WB_Ctrl),
        .rs1(rs1_src),.rs2(Inst[`IR_rs2]),.rd(MEM_WB_rd),
        .write_data(MEM_WB_RegW),.read_data1(RegR1),.read_data2(RegR2));//RegW, Rd and WriteEn from pipeline MEM/WB
    //ID STAGE END  
    //EX STAGE
    Mux2_1 #(32) shamtMux(.sel(ID_EX_Ctrl[12]), .in1(ID_EX_RegR2), .in2(ID_EX_ImmGen), .out(shamt));//add shamt to pipe
    Mux2_1 #(32) aluSrcBMux(ID_EX_Ctrl[11],ID_EX_RegR2,ID_EX_ImmGen,ALUSrcMux_out);//add multiplexers for load-use hazards rs1 and rs2.
    ALUControl acu(.ALUOp(ID_EX_Ctrl[10:9]),.func3(ID_EX_func3),.func7(ID_EX_func7),.sel(ALUSel));
    prv32_ALU alu(.a(ID_EX_RegR1), .b(ALUSrcMux_out), .shamt(shamt[4:0]), .r(ALU_out),
        .cf(cf), .zf(Zero), .vf(vf), .sf(sf), .alufn(ALUSel));//remove the flags from the alu
   
    //EX STAGE END
    //MEM STAGE
    DataMem dmem(clk,rst,EX_MEM_Ctrl[8],EX_MEM_Ctrl[7],EX_MEM_Ctrl[6],EX_MEM_Ctrl[5],EX_MEM_Ctrl[4],EX_MEM_ALU_out[7:0],EX_MEM_RegR2,Mem_out);//fix address width
    Mux2_1 #(32) regWSrcMux(EX_MEM_Ctrl[3],EX_MEM_ALU_out,Mem_out,regWSrcMuxOut);
    Mux4_1 #(32) regWsrcMux1(.sel(EX_MEM_Ctrl[2:1]), .in1(regWSrcMuxOut), .in2(EX_MEM_BranchAdder_out), .in3(EX_MEM_PCAdder_out), .in4(0), .out(RegW));//don't forget to pass addr. in pipeline
    //MEM STAGE END
    
    //Variables output on the FPGA's 7-seg display and LEDs need to be picked from the pipeline.
    
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
