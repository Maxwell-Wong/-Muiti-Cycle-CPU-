`timescale 1ns / 1ps
module Data_Memory(
    input CLK,
    input [31:0]Daddr,
    input [31:0]DataIn,
    input mRD,mWR,
    output reg [31:0]DataOut
    );
    reg [7:0]mem[255:0];
    integer i;
    initial begin
    for(i=0;i<256;i=i+1)
        mem[i]<=0;
    end
    always@(Daddr or mRD)
        begin
           if(mRD==1)
              begin
                DataOut[31:24] = mem[Daddr]; //8bits per unit ,big endian
                DataOut[23:16] = mem[Daddr+1];
                DataOut[15:8] = mem[Daddr+2];
                DataOut[7:0] = mem[Daddr+3];
              end    
        end
     always@(negedge CLK)
        begin
            if(mWR==1)
                begin
                   mem[Daddr] <= DataIn[31:24];
                   mem[Daddr+1] <= DataIn[23:16];
                   mem[Daddr+2] <= DataIn[15:8];
                   mem[Daddr+3] <= DataIn[7:0];
                end
        end
endmodule
