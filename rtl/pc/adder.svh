module adder #(
    parameter WIDTH = 32
)(
    input logic [WIDTH-1:0] PCF,
    output logic [WIDTH-1:0] PCPlus4F
);

    assign PCPlus4F = PCF + 32'd4;

endmodule
