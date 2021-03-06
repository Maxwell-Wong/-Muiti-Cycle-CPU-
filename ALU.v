`timescale 1ns / 1ps
module ALU(
    input [31:0] A,B,
    input [2:0] ALUOp,
    output reg [31:0]result,
    output zero,sign
    );    
   always@(*)
    begin
       case(ALUOp)
        3'b000:result = A+B;
        3'b001:result = A-B;
        3'b010:result = B<<A;
        3'b011:result = A|B;
        3'b100:result = A&B;
        3'b101:result = A<B?1:0;
        3'b110:result = ((A<B&&A[31]==B[31])||(A[31]==1&&B[31]==0)?1:0);
        3'b111:result = A^B;
        default: result = 0;
        endcase
    end
   assign zero = result==0;
  assign sign = result[31]==1;
      
endmodule
