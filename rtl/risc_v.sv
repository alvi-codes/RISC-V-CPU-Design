// include all created components
`include "control_unit/instr_mem/instr_mem.svh"
`include "control_unit/control_unit/control_unit.svh"
`include "control_unit/sign_extend/sign_extend.svh"
`include "pc/pc_mux.svh"
`include "pc/pcReg.svh"
`include "alu/alusrc.svh"
`include "alu/alu.svh"
`include "alu/reg_file.svh"
`include "alu/data_mem.svh"


// create top level module
module risc_v #(
    parameter ADDRESS_WIDTH = 8,
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    output logic [DATA_WIDTH-1:0] a0,
    output logic [DATA_WIDTH-1:0] instruction,
    output logic [7:0] pc_addr
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

always_ff @(posedge clk)
    begin
        //Only add logic which must be going into the next block
        //Once done remove all comments for your block and add any comments if neccessary
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
logic           RdD;
logic           ImmExtD;
logic [DATA_WIDTH-1:0]  a0;


control_unit #(DATA_WIDTH) my_control_unit(
    .instr (instrD),
    .RegWrite (RegWriteD),
    .ResultSrc (ResultSrcD),
    .MemWrite (MemWriteD),
    .Jump (JumpD),
    .Branch (BranchD),
    .ALUControl (ALUControlD),
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
        RD2D <= RD2D;
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
logic           RdE;
logic           ImmExtE;

// unique
logic [ADDRESS_WIDTH-1:0] ALUResultE;
logic           EQ;
logic           PCSrcE;
logic           ZeroE;

alu alu (
    .ALUop1 (RD1E),
    .ALUop2 (ALUSrcE ? ImmExtE : RD2E),
    .ALUctrl (ALUControlE),
    .ALUout (ALUResultE),
    .EQ (EQ),
    .ZeroE (ZeroE)
);

jumpbranch jumpbranch(
    .ZeroE (ZeroE),
    .JumpE (JumpE),
    .BranchE (BranchE),
    .PCSrcE (PCSrcE)
);

// @ SHERMAINE, I don't really need to add a component here for the PC TargetE adder, you can just put it in your PC muxer later with PCE and ImmExtE

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

always_ff @(posedge clk)
    begin
        //Only add logic which must be going into the next block
        //Once done remove all comments for your block and add any comments if neccessary
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





// These logics are for testing output
assign pc_addr = pc[7:0];
assign instruction = instr;

endmodule
