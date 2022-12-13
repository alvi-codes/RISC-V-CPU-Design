module pcReg #(
    parameter WIDTH = 32
)(
    input logic clk, 
    input logic rst, 
    input logic [WIDTH-1:0] PCF0,
    output logic [WIDTH-1:0] PCF
);

always_ff @ (posedge clk)
    begin
    if (rst) PCF <= {WIDTH{1'b0}};
    else PCF <= PCF0;
    end
endmodule
