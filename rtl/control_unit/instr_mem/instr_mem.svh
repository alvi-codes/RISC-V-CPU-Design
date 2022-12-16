module instr_mem #(
    parameter  ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0] A,
    output logic [DATA_WIDTH-1:0]   RD
);

    logic [DATA_WIDTH-1:0] rom_array [32'hBFC00FFF:32'hBFC00000];
    
    initial begin
        $readmemh("test_instructions.mem", rom_array, 32'hBFC00000);
    end;

    always_comb begin
        // async output
        RD = rom_array[A];
    end

endmodule
