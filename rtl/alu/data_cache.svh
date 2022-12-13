module data_cache #(
    parameter ADDRESS_WIDTH = 32,
    parameter SRAM_WIDTH = 60,
    parameter DATA_WIDTH = 32,
    parameter TAG_WIDTH = 27,
    parameter SET_WIDTH = 3,
) (
    input   logic     [SET_WIDTH-1:0]         set,
    output  logic                             V,
    output  logic     [TAG_WIDTH-1:0]         tag,
    output  logic     [DATA_WIDTH-1:0]        data
);

    logic   [DATA_WIDTH-1:0]     data_cache_register     [SRAM_WIDTH-1:0];  //@clemenkok not too sure about this

    always_ff 
    begin
        V <= data_cache_register[set][SRAM_WIDTH-1];
        tag <= data_cache_register[set][SRAM_WIDTH-2:ADDRESS_WIDTH];
        data <= data_cache_register[set][ADDRESS_WIDTH-1:0]; //how does data even get stored in the first place??
    end

endmodule
