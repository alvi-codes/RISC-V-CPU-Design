module cachebranch (
    input logic                     tag,
    input logic                     V,
    input logic                     memAddrTag,
    output logic                    hit
);

logic branch;

assign branch = tag == memAddrTag;
assign hit = branch && V;
    
endmodule