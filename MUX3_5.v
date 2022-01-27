`timescale 1ps/1ps
module MUX3_5(
    input enable,
    input [4:0]data1,
    input [4:0]data2,
    output [4:0]Out

    assign Out = enable?data1:data2;

);

endmodule