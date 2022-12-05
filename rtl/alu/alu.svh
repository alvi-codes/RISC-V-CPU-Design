module alu #(
    CONTROL_WIDTH = 3,
    INPUT_WIDTH = 32
) (
    input logic     [INPUT_WIDTH-1:0]   ALUop1,
    input logic     [INPUT_WIDTH-1:0]   ALUop2,
    input logic     [CONTROL_WIDTH-1:0] ALUctrl,
    output logic    [INPUT_WIDTH-1:0]   ALUout,
    output logic                        EQ // controlled by ALUctrl for branching
);

    always_comb
        case (ALUctrl)
            3'h0:   ALUout = ALUop1 + ALUop2;
            3'h1:   ALUout = ALUop1 - ALUop2;
            3'h2:   ALUout = ALUop1 & ALUop2;
            3'h3:   ALUout = ALUop1 | ALUop2;
            3'h4:   ALUout = 0;
            3'h5:   ALUout = ALUop1 < ALUop2 ? 1 : 0; // SET LESS THAN operation
            3'h6:   ALUout = 0;
            3'h7:   ALUout = 0;
        endcase

    always_comb
        case (ALUctrl)
            3'h0:   EQ = ALUop1 == ALUop2;
            3'h1:   EQ = ALUop1 != ALUop2;
            3'h2:   EQ = ALUop1 < ALUop2;
            3'h3:   EQ = ALUop1 >= ALUop2;
            3'h4:   EQ = 0;
            3'h5:   EQ = 0;
            3'h6:   EQ = 0;
            3'h7:   EQ = 0;
        endcase

    
endmodule
