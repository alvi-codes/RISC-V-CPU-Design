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
    parameter ADDRESS_WIDTH = 32,
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
        3) Fill the always_ff block by with: Data block logic = Fetch block logic

    Remember:
        * All logic in your block must always end with F. example: PCF
        * Each logic in always_ff must have same name with different suffix, example instrF = instrD
        * always_ff block has been created, just fill in
*/

always_ff @(posedge clk)
    begin
        //Only add logic which must be going into the next block
        //Once done remove all comments for your block and add any comments if neccessary
    end






// DATA Block

/*
    Todo:
        1) First create logics for each wire to be used in Data block
        2) Use the right components from ones included as in the diagram
        3) Fill the always_ff block by with: Execute block logic = Data block logic
        4) Assign a0 to right value from the register

    Remember:
        * All logic in your block must always end with D. example: RdD
        * Each logic in always_ff must have same name with different suffix, example JumpE = JumpD
        * always_ff block has been created, just fill in
*/

always_ff @(posedge clk)
    begin
        //Only add logic which must be going into the next block
        //Once done remove all comments for your block and add any comments if neccessary
    end






// EXECUTE Block

/*
    Todo:
        1) First create logics for each wire to be used in Execute block
        2) Use the right components from ones included as in the diagram
        3) Fill the always_ff block by with: Memory block logic = Execute block logic

    Remember:
        * All logic in your block must always end with E. example: ImmExtE
        * Each logic in always_ff must have same name with different suffix, example ALUResultM = ALUResultE
        * always_ff block has been created, just fill in
*/

always_ff @(posedge clk)
    begin
        //Only add logic which must be going into the next block
        //Once done remove all comments for your block and add any comments if neccessary
    end






// MEMORY Block

/*
    Todo:
        1) First create logics for each wire to be used in Memory block
        2) Use the right components from ones included as in the diagram
        3) Fill the always_ff block by with: Write block logic = Memory block logic

    Remember:
        * All logic in your block must always end with M. example: MemWriteM
        * Each logic in always_ff must have same name with different suffix, example ReadDataW = ReadDataM
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
