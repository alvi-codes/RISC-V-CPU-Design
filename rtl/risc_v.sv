// include all created components
`include "control_unit/instr_mem/instr_mem.sv"
`include "control_unit/control_unit/control_unit.sv"
`include "control_unit/sign_extend/sign_extend.sv"
`include "pc/pc_mux.sv"
`include "pc/pcReg.sv"
`include "alu/alusrc.sv"
`include "alu/alu.sv"
`include "alu/reg_file.sv"
`include "alu/data_mem.sv"


// create top level module
module risc_v #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    output logic [DATA_WIDTH-1:0] a0,
    output logic [DATA_WIDTH-1:0] instruction,
    output logic [7:0] pc_addr
);



logic                     PCsrc, EQ, RegWrite, ALUsrc, MEMWrite, MEMsrc;
logic [ADDRESS_WIDTH-1:0] ImmOp, pc;
logic [4:0]               rs1, rs2, rd;
logic [2:0]               ALUctrl;
logic                     JALsrc, JALRsrc;

//Top_CU
logic   [DATA_WIDTH-1:0]    instr;
logic   [1:0]              ImmSrc;

assign rs1  = instr[19:15];
assign rs2  = instr[24:20];
assign rd   = instr[11:7];

instr_mem #(8, DATA_WIDTH) my_instr_mem( //Changing 8 to 32 generates a memory error: 
                                            // %Error: test_instructions.mem:0: $readmem file address beyond bounds of array
                                            // Aborting...
                                            // Aborted (core dumped)
    .pc (pc[7:0]),      
    .instr (instr)  
);
control_unit #(DATA_WIDTH) my_control_unit(
    .instr (instr),
    .EQ (EQ),
    .RegWrite (RegWrite),
    .ALUctrl (ALUctrl),
    .ALUsrc (ALUsrc),
    .ImmSrc (ImmSrc),
    .PCsrc (PCsrc),
    .JALsrc (JALsrc),
    .JALRsrc (JALRsrc),
    .MEMWrite (MEMWrite),
    .MEMsrc (MEMsrc)
);
sign_extend #(DATA_WIDTH) my_sign_extend(
    .instr (instr),
    .ImmSrc (ImmSrc),    
    .ImmOp (ImmOp)
);



//Top_PC
logic [ADDRESS_WIDTH-1:0] next_PC;

pc_mux #(ADDRESS_WIDTH) pc_mux(
    .PCsrc (PCsrc),
    .ImmOp (ImmOp),
    .next_PC (next_PC),
    .pc (JALRsrc ? (ALUop1+ImmOp) : pc)
);
pcReg #(ADDRESS_WIDTH) pcReg(
    .clk (clk),
    .rst (rst),
    .next_PC (next_PC),
    .pc (pc)
);



//Top_ALU
logic [ADDRESS_WIDTH-1:0] ALUop1, ALUop2, regOp2, ALUout, MEMdata, RegData;

alusrc #(ADDRESS_WIDTH) alusrc (
    .regOp2 (RD2E),
    .ImmOp (ImmExtE),
    .ALUsrc (ALUSrcE),
    .ALUop2 (ALUop2)
);
alu #(3, ADDRESS_WIDTH) alu (
    .ALUop1 (RD1E),
    .ALUop2 (ALUop2),
    .ALUctrl (ALUControlE),
    .ALUout (ALUout),
    .EQ (EQ),
    .ZeroE (ZeroE)
);
reg_file #(5, DATA_WIDTH)reg_file (
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (RegWrite),
    .WD3 (JALsrc ? (pc) : (ResultW)), // changed to ResultW using memsrc mux
    .RD1 (ALUop1),
    .RD2 (regOp2),
    .a0 (a0)
);
data_mem #(8, 32) data_mem (
    .clk (clk),
    .WE (MEMWrite),
    .A (ALUResultM[7:0]),
    .WD (RD2E),
    .RD (MEMdata)
);
memsrc #(ADDRESS_WIDTH) memsrc ( // what does the #(ADDRESS_WIDTH) do
    .ReadDataW (ReadDataW),
    .PCPlus4W (PCPlus4W),
    .MEMSrcW (MEMSrcW),
    .ResultW (ResultW)
);

assign pc_addr = pc[7:0];
assign instruction = instr;

// Pipelining

// Pipeline Stage D (F to D)
logic [ADDRESS_WIDTH-1:0] InstrD, PCD, PCPlus4D, ImmExtD;

always_ff @ (posedge clk) begin

    // stage F -> D
    InstrD <= instr;
    PCPlus4D <= pc + 32'd4; 
    PCD <= pc;
    ImmExtD <= ImmOp;

end

// Pipeline Stage E
logic                     RegWriteE, MEMWriteE, JumpE, BranchE, ALUSrcE;
logic [1:0]               MEMSrcE;
logic [2:0]               ALUControlE;
logic [ADDRESS_WIDTH-1:0] RD1E, RD2E, PCE, RdE, ImmExtE, PCPlus4E;

always_ff @ (posedge clk) begin

    // stage D->E (ctrl unit | register file | sign extend (D) -> ALU (E))

    // ctrl unit
    RegWriteE <= RegWrite;
    MEMSrcE <= MEMsrc;
    MEMWriteE <= MEMWrite;
    // JumpE yet to be added, missing JumpD.  
    // BranchE yet to be added, missing BranchD 
    ALUControlE <= ALUctrl;
    ALUSrcE <= ALUsrc;

    // alu
    RD1E <= ALUOp1;
    RD2E <= regOp2;
    PCE <= PCD;
    // (done?) PCE yet to be added, missing PCD. @shermaine Note that PCE and ImmExtE should be added to give PCTargetE
    // not too sure how PCTargetE should be connected
    RdE <= InstrD[11:7]; // changed from instr to InstrD
    ImmExtE <= ImmExtD; // changed from ImmOp to ImmExtD
    PCPlus4E <= PCPlus4D;
    // (done) PCPlus4E yet to be added, missing PCPlus4D. PCPlus4D comes from a DFF in the PC. We can discuss + do this on the 5th

end

// Pipeline Stage M
logic                     RegWriteM, MEMWriteM;
logic [1:0]               MEMSrcM;
logic [ADDRESS_WIDTH-1:0] ALUResultM, WriteDataM, RdM, PCPlus4M;

always_ff @ (posedge clk) begin

    // stage F->M (ALU (E) -> Data Memory (M))

    // ctrl unit
    RegWriteM <= RegWriteE;
    MEMSrcM <= MEMSrcE;
    MEMWriteM <= MEMWriteE;

    // alu
    ALUResultM <= ALUout;
    WriteDataM <= RD2E; // RD2E == WriteDataE
    RdM <= RdE;
    PCPlus4M <= PCPlus4E; // note missing PCPlus4D

end

// Pipeline Stage W
logic                     RegWriteW;
logic [1:0]               MEMSrcW;
logic [ADDRESS_WIDTH-1:0] ReadDataW, RdW, PCPlus4W, ALUResultW;

always_ff @ (posedge clk) begin

    // stage M->W (Data Memory (M) -> PC (W))

    // ctrl unit
    RegWriteW <= RegWriteM;
    MEMSrcW <= MEMSrcM;

    //alu
    ALUResultW <= ALUResultM;
    ReadDataW <= MEMdata;
    RdW <= RdM;
    PCPlus4W <= PCPlus4M;
end

endmodule