`timescale 1ns / 1ps
module Temp_Res(
    input CLK,
    input RW,
    input [31:0]data;
    output reg[31:0]out;
    
    //reg [31:0] Res;
    integer i;
    always @(negedge CLK or posedge RW) begin
        if(RW==1)
            out<=data;
    end
)
endmodule