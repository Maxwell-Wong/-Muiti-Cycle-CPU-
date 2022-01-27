`timescale 1ps/1ps
module MUX2_32(
    input enable,
    input [31:0]Data1,
    input [31:0]Data2,
    output [31:0]Out;

   assign Out = enable?Data1:Data2;

);

endmodule