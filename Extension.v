`timescale 1ns / 1ps
module Extension(
    input ExtSel,
    input [15:0]immediate,
    output [31:0] res
    );
    assign res = {ExtSel&&immediate[15]?16'hffff:16'h0000,immediate};
    
endmodule
