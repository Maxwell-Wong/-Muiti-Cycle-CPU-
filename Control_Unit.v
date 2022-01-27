`timescale 1ns / 1ps
module Control_Unit(
    input CLK,
    input zero,sign,
    input [5:0]op,
    input [5:0]func,
    input  Reset,
    output PCWre,
    output RegWre,
    output ExtSel,
    output InsMemRw,
    output DBDataSrc,
    output [1:0]RegDst,
    output ALUSrcA,
    output ALUSrcB,
    output [1:0] PCSrc,
    output mRD,
    output mWR,
    output [2:0] ALUOp,
    output WrRegDSrc,
    output IRWre
    );

    //Five states
    parameter [2:0] 
        IF = 3'b000;
        ID = 3'b001;
        EXE_RI = 3'b110;
        EXE_B = 3'b100;
        EXE_SL = 3'b010;
        MEM = 3'b011;
        WB_LW = 3'b100;
        WB_RI = 3'b111;

    parameter halt = 6'b111111;
    parameter addiu = 6'b001001;
    parameter ori = 6'b001101;
    parameter bne =6'b000101;
    parameter slti = 6'b001010;
    parameter beq = 6'b110000;
    parameter sw = 6'b101011;
    parameter lw = 6'b100011;
    parameter bltz = 6'b000001;
    parameter j = 6'b000010;
    parameter andi = 6'b001000;
    parameter add_func = 6'b100000;
    parameter sub_func = 6'b100010; 
    parameter and_func = 6'b100100;
    parameter or_func=  6'b100101;
    parameter sll_func = 6'b000000;
    parameter add_ = 3'b000;
    parameter sub_ = 3'b001;
    parameter sll_ = 3'b010;
    parameter or_ =  3'b011;
    parameter and_ = 3'b100;
    parameter slti_ = 3'b110;
    parameter xor_ = 3'b111;
   

    parameter jal = 6'b000011;
    parameter xori = 6'b001110;
    parameter slt_func = 6'b101010;
    parameter jr_func = 6'b001000;

   wire RegWre_func ;
   wire ALUOp_sub;
   wire ALUOp_add;
   wire ALUOp_and;
   wire ALUOp_or;

   reg [2:0] States;

  initial begin
     States = 0;
     PCWre=0;
     RegWre=0;
     ExtSel=0;
     InsMemRw=0;
     DBDataSrc=0;
     RegDst=0;
     ALUSrcA=0;
     ALUSrcB=0;
     PCSrc=0;
     mRD=0;
     mWR=0;
     ALUOp=0;
     WrRegDSrc=0;
     IRWre=1;
  end
  always @(negedge CLK or posedge Reset) begin
    if(Reset==0)begin
      States = IF;
      PCWre = 0;
      RegWre = 0;
    end
    else begin
      case(States)
          IF:begin
            IRWre = 0;
            PCWre = 0;
            RegWre = 0;
            mWR = 0;
            States <= ID;
          end
          ID:begin
            if(op==beq||op==bne||op==bltz)
              States<= EXE_B;
            else if(op==sw||op==lw)
              States<=EXE_SL;
            else if(op==j||op==jal||func==jr_func||op==halt)
              begin
                 if(op==halt) PCWre = 0;
                 else PCWre=1;
                 if(op==jal) RegWre = 1;
                 else RegWre = 0;
                 States<=IF;
              end
            else States<=EXE_RI;
            // case(op)
            //   beq,bne,bltz:States<= EXE_B;
            //   sw,lw:States<=EXE_SL;
            //   j,jal,jr,halt:begin
            //     if(op==halt) PCWre = 0;
            //     else PCWre=1;
            //     if(op==jal) RegWre = 1;
            //     else RegWre = 0;
            //   end 
            //   default: States<=EXE_RI
            // endcase 
          end    
          EXE_RI:begin
            RegWre = 1;
            States<=WB_RI;
          end
          // EXE_B:begin
          //   States<=IF;
          // end
          EXE_SL:begin
            if(op==sw) mWR = 1;
            else mWR = 0;
            if(op==lw) mRD = 1;
            else mRD = 0;
            States<=MEM;
          end
          MEM:begin
            if(op==lw)begin
              RegWre = 1;
              States<=WB_LW;
            end
            if(op==sw)begin
              IRWre = 1;
              PCWre = 1;
              States<=IF;
            end
          end
        default:begin
           PCWre=1;
           IRWre = 1;
           States<=IF;
        end
        endcase
    end
  end

always @(op or zero or sign or func) begin

    RegWre_func = func==add_func||func==sub_func||func==or_func||func==and_func||func==sll_func;
    ALUOp_sub = func==sub_func||op==bne||op==beq||op==bltz;
    ALUOp_add = func==add_func||op==addiu;
    ALUOp_and = func==and_func||op==andi;
    ALUOp_or = func==or_func||op==ori;
    PCWre = op!=halt;
    ALUSrcA = func==sll_func;
    ALUSrcB = op==addiu||op==andi||op==ori||op==slti||op==sw||op==lw;
    DBDataSrc = op==lw;
    RegWre = RegWre_func||op==addiu||op==ori||op==andi||op==slti||func==slt_func||op==lw||op==jal||op==xori;
    InsMemRw = 1;
    mRD = op==lw;
    mWR = op==sw;
    RegDst = (func==add_func||func==slt_func||func==sub_func||func==sll_func||func==and_func)?2'b10:op==jal?2'b00:(op==addiu||op==andi||op==ori||op==xori||op==slti||op==lw)?2'b01:2'b11;
    ExtSel = op!=andi&&op!=ori&&op!=xori;  //op==slti||op==sw||op==lw||op==beq||op==bne||op==bltz||op==addiu;
    PCSrc[0] = (op==beq&&zero==1)||(op==bne&&zero==0)||(op==bltz&&sign==1)||op==jal||op==j ;
    PCSrc[1] = op==j||func==jr_func||op==jal;
    ALUOp = ALUOp_add?add_:ALUOp_sub?sub_:ALUOp_or?or_:func==sll_func?sll_:op==slti?slti_:ALUOp_and?and_:op==xori?xor_:add_;
    WrRegDSrc = op!=jal; //待检查 add、addiu、sub、and、andi、ori、xori、sll、slt、slti、lw
    IRWre = 1; //指令寄存器写使能
end





















  //  assign RegWre_func = func==add_func||func==sub_func||func==or_func||func==and_func||func==sll_func;
  //  assign ALUOp_sub = func==sub_func||op==bne||op==beq||op==bltz;
  //  assign ALUOp_add = func==add_func||op==addiu;
  //  assign ALUOp_and = func==and_func||op==andi;
  //  assign ALUOp_or = func==or_func||op==ori;
  //  assign PCWre = op!=halt;
  //  assign ALUSrcA = func==sll_func;
  //  assign ALUSrcB = op==addiu||op==andi||op==ori||op==slti||op==sw||op==lw;
  //  assign DBDataSrc = op==lw;
  //  assign RegWre = RegWre_func||op==addiu||op==ori||op==andi||op==slti||op==lw;
  //  assign InsMemRw = 1;
  //  assign mRD = op==lw;
  //  assign mWR = op==sw;
  //  assign RegDst = (func==add_func||func==slt_func||func==sub_func||func==sll_func||func==and_func)?2'b10:op==jal?2'b00:(op==addiu||op==andi||op==ori||op==xori||op==slti||op==lw)?2'b01:2'b11;
  //  assign ExtSel = op!=andi&&op!=ori;  //op==slti||op==sw||op==lw||op==beq||op==bne||op==bltz||op==addiu;
  //  assign PCSrc[0] = (op==beq&&zero==1)||(op==bne&&zero==0)||(op==bltz&&sign==1)||op==jal;
  //  assign PCSrc[1] = op==j||func==jr_func||op==jal;
  //  assign ALUOp = ALUOp_add?add_:ALUOp_sub?sub_:ALUOp_or?or_:func==sll_func?sll_:op==slti?slti_:ALUOp_and?and_:111;
  //  assign WrRegDSrc = op==jal?1'b0:1'b1;  //待检查 add、addiu、sub、and、andi、ori、xori、sll、slt、slti、lw
  //  assign IRWre = 1 //指令寄存器写使能
   
   
endmodule
