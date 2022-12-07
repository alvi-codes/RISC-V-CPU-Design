// include all created components
`include "control_unit/instr_mem/instr_mem.svh"
`include "control_unit/control_unit/control_unit.svh"
`include "control_unit/sign_extend/sign_extend.svh"
`include "pc/adder.svh"
`include "pc/pcReg.svh"
`include "alu/alu.svh"
`include "alu/reg_file.svh"
`include "alu/data_mem.svh"
`include "alu/jumpbranch.svh"


// create top level module
module risc_v #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MODIFIED_INSTR_MEM_WIDTH = 8
)(
    input logic clk,
    input logic rst,
    output logic [DATA_WIDTH-1:0] a0,
    output logic [DATA_WIDTH-1:0] instruction,
    output logic [11:0] pc_addr
);






// FETCH Block

/*
    Todo:
        1) First create logics for each wire to be used in Fetch block
        2) Use the right components from ones included as in the diagram
        3) Fill the always_ff block by with: Data block logic <= Fetch block logic

    Remember:
        * All logic in your block must always end with F. example: PCF
        * Each logic in always_ff must have same name with different suffix, example instrD <= instrF
        * always_ff block has been created, just fill in
*/

logic [31:0]    instrF;
logic [ADDRESS_WIDTH-1:0]  PCF, PCPlus4F;

pcReg pcReg(
    .clk (clk),
    .rst (rst),
    .PCF0 (PCSrcE ? (PCE+ImmExtE) : PCPlus4F),
    .PCF (PCF)
);

instr_mem #(MODIFIED_INSTR_MEM_WIDTH, DATA_WIDTH) instr_mem(   //Changing 12 to 32 generates a memory error: 
                                            // %Error: test_instructions.mem:0: $readmem file address beyond bounds of array
                                            // Aborting...
                                            // Aborted (core dumped)
    .A (PCF[MODIFIED_INSTR_MEM_WIDTH-1:0]),
    .RD (instrF)     
);

adder adder(
    .PCF (PCF),
    .PCPlus4F (PCPlus4F)
);

always_ff @(posedge clk)
    begin
        instrD <= instrF;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
    end






// DATA Block


logic [31:0]    instrD;
logic           RegWriteD;
logic [1:0]     ResultSrcD;
logic           MemWriteD;
logic           JumpD;
logic           BranchD;
logic [2:0]     ALUControlD;
logic           ALUSrcD;
logic [1:0]     ImmSrcD;
logic [31:0]    RD1D, RD2D;
logic [ADDRESS_WIDTH-1:0]   PCD, PCPlus4D;
logic [4:0]     RdD;
logic [DATA_WIDTH-1:0]  ImmExtD;


control_unit #(DATA_WIDTH) my_control_unit(
    .instr (instrD),
    .RegWrite (RegWriteD),
    .ResultSrc (ResultSrcD),
    .MemWrite (MemWriteD),
    .Jump (JumpD),
    .Branch (BranchD),
    .ALUctrl (ALUControlD),
    .ALUsrc (ALUSrcD),
    .ImmSrc (ImmSrcD)
);

reg_file #(5, DATA_WIDTH)reg_file (
    .clk (clk),
    .AD1 (instrD[19:15]),
    .AD2 (instrD[24:20]),
    .AD3 (RdW),
    .WE3 (RegWriteW),
    .WD3 (ResultW),
    .RD1 (RD1D),
    .RD2 (RD2D),
    .a0 (a0)
);

sign_extend #(DATA_WIDTH) my_sign_extend(
    .instr (instrD),
    .ImmSrc (ImmSrcD),    
    .ImmOp (ImmExtD)
);

assign RdD = instrD[11:7];

always_ff @(posedge clk)
    begin
        RegWriteE <= RegWriteD;
        ResultSrcE <= ResultSrcD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        PCE <= PCD;
        RdE <= RdD;
        ImmExtE <= ImmExtD;
        PCPlus4E <= PCPlus4D;
    end






// EXECUTE Block

/*
    Todo:
        1) First create logics for each wire to be used in Execute block
        2) Use the right components from ones included as in the diagram
        3) Fill the always_ff block by with: Memory block logic <= Execute block logic

    Remember:
        * All logic in your block must always end with E. example: ImmExtE
        * Each logic in always_ff must have same name with different suffix, example ALUResultM <= ALUResultE
        * always_ff block has been created, just fill in
*/

// pipeline IO
logic [31:0]    instrE;
logic           RegWriteE;
logic [1:0]     ResultSrcE;
logic           MemWriteE;
logic           JumpE;
logic           BranchE;
logic [2:0]     ALUControlE;
logic           ALUSrcE;
logic [1:0]     ImmSrcE;
logic [31:0]    RD1E, RD2E;
logic [ADDRESS_WIDTH-1:0]   PCE, PCPlus4E;
logic [4:0]     RdE;
logic [DATA_WIDTH-1:0]  ImmExtE;

// unique
logic [ADDRESS_WIDTH-1:0] ALUResultE;
logic           PCSrcE;
logic           ZeroE;

alu alu (
    .ALUop1 (RD1E),
    .ALUop2 (ALUSrcE ? ImmExtE : RD2E),
    .ALUctrl (ALUControlE),
    .ALUout (ALUResultE),
    .ZeroE (ZeroE)
);

jumpbranch jumpbranch(
    .ZeroE (ZeroE),
    .JumpE (JumpE),
    .BranchE (BranchE),
    .PCSrcE (PCSrcE)
);

always_ff @(posedge clk)
    begin
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        ALUResultM <= ALUResultE;
        WriteDataM <= RD2E;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
    end


// MEMORY Block

/*
    Todo:
        1) First create logics for each wire to be used in Memory block
        2) Use the right components from ones included as in the diagram
        3) Fill the always_ff block by with: Write block logic <= Memory block logic

    Remember:
        * All logic in your block must always end with M. example: MemWriteM
        * Each logic in always_ff must have same name with different suffix, example ReadDataW <= ReadDataM
        * always_ff block has been created, just fill in
*/

logic                       RegWriteM;
logic [1:0]                 ResultSrcM;
logic                       MemWriteM;
logic [ADDRESS_WIDTH-1:0]   ALUResultM, PCPlus4M;
logic [DATA_WIDTH-1:0]      WriteDataM, ReadDataM;
logic [4:0]                 RdM;

data_mem #(MODIFIED_INSTR_MEM_WIDTH, DATA_WIDTH) data_mem(
    .clk(clk),
    .A(ALUResultM),
    .WE(MemWriteM),
    .WD(WriteDataM),
    .RD(ReadDataM)
);

always_ff @(posedge clk)
    begin
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
    end

// Write Block

/*
    Todo:
        1) First create logics for each wire to be used in Write block
        2) Use the right components from ones included as in the diagram
        3) There is no delay in this block, so dont add always_ff

    Remember:
        * All logic in your block must always end with W. example: ReadDataW
*/

logic                       RegWriteW;
logic [1:0]                 ResultSrcW;
logic [ADDRESS_WIDTH-1:0]   ALUResultW, PCPlus4W;
logic [DATA_WIDTH-1:0]      ResultW, ReadDataW;
logic [4:0]                 RdW;

    always_comb
        case (ResultSrcW)
            2'h0:   ResultW = ALUResultW;
            2'h1:   ResultW = ReadDataW;
            2'h2:   ResultW = PCPlus4W;
            default: ResultW = {DATA_WIDTH{1'b0}};
        endcase


// These logics are for testing output
assign pc_addr = PCF[MODIFIED_INSTR_MEM_WIDTH-1:0];
assign instruction = instrF;

endmodule
