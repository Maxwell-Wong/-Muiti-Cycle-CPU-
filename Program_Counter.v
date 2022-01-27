`timescale 1ns / 1ps
module Program_Counter(
    input RST,PCWre,CLK,
    input [31:0] new_addr,
    input [2:0]State;
    output reg [31:0] PC
);
initial begin
    PC = 0;
end
 always@(posedge CLK or negedge RST)
    begin
        if(RST==0)
            begin 
            PC  = 0;
            end
        else    
            if(PCWre==1)
              begin
                PC = new_addr;
              end
    end
endmodule