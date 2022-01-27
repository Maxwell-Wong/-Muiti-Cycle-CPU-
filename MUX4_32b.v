`timescale 1ps/1ps
module MUX4_32(
    input [1:0]enable,
    input [31:0]Data1,
    input [31:0]Data2,
    input [31:0]Data3,
    input [31:0]Data4,
    output [31:0]Out;

   assign Out = enable==2'b11?Data4:enable==2'b10?Data3:enable==2'b01?Data2:Data1;

);

endmodule