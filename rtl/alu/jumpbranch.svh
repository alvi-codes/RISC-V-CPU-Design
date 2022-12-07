module jumpbranch (
    input logic                     ZeroE,
    input logic                     BranchE,
    input logic                     JumpE,
    output logic                    PCSrcE
);

logic branch;

assign branch = ZeroE && BranchE;
assign PCSrcE = branch || JumpE;
    
endmodule
