`timescale 1ns / 1ps
module Register_File(
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] Write_Reg,
    input WE,CLK,
    input [31:0] Write_Data,
    output  [31:0] Read_Data1,
    output  [31:0] Read_Data2
    ); 
    
    reg [31:0] registers [0:31];
    integer i;
    
    initial begin  
             for (i = 0; i < 32; i = i+1) registers[i] <= 0;  
            end  
   assign  Read_Data1 = rs?registers[rs]:0;
   assign  Read_Data2 = rt?registers[rt]:0;
    
    always@(negedge CLK )
    begin
            if(WE&&Write_Reg) begin
            registers[Write_Reg] = Write_Data;
            end
    end
endmodule
