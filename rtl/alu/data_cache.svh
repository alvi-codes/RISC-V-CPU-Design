module data_cache #(
    parameter ADDRESS_WIDTH = 32,
    parameter SRAM_WIDTH = 60,
    parameter DATA_WIDTH = 32,
    parameter TAG_WIDTH = 27,
    parameter SET_WIDTH = 3,
) (
    input   logic     [SET_WIDTH-1:0]         set,
    input   logic     [DATA_WIDTH-1:0]        WD,
    input   logic                             WE,      
    output  logic                             V,
    output  logic     [TAG_WIDTH-1:0]         tag,
    output  logic     [DATA_WIDTH-1:0]        RD
);

    logic   [DATA_WIDTH-1:0]     data_cache_register     [SRAM_WIDTH-1:0];

    always_ff 
    begin

        V <= data_cache_register[set][SRAM_WIDTH-1];
        tag <= data_cache_register[set][SRAM_WIDTH-2:ADDRESS_WIDTH];
        RD <= data_cache_register[set][ADDRESS_WIDTH-1:0]; 

        if (WE == 1'b1) // if WRITE Enable, feed WD into A Register
            data_cache_register[set]<= WD;
            data_cache_register[set][SRAM_WIDTH-1] <= 1'b1; // valid bit adjustment

    end

endmodule
