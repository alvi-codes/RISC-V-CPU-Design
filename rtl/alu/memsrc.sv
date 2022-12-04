module memsrc #(
    parameter WIDTH = 32
) (
    input logic     [WIDTH-1:0]     ALUResultM,
    input logic     [WIDTH-1:0]     ReadDataW,
    input logic     [WIDTH-1:0]     PCPlus4W,
    input logic     [1:0]           MEMSrcW,
    output logic    [WIDTH-1:0]     ResultW
);
    
    always_comb begin
        case (MEMSrcW)
        2'h0:   ResultW = ALUResultM;
        2'h1:   ResultW = ReadDataW;
        2'h2:   ResultW = PCPlus4W;
        2'h3:   ResultW = 0;
        endcase
    end

endmodule
