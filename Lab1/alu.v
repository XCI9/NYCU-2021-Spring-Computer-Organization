`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;


reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;
wire   [32-1:0] carryTemp;
wire   [32-1:0] resultTemp;

wire set;
wire minus;

assign minus =  (ALU_control[2:1] == 2'b11);   //sub or slt mode

alu_top    aluUnit0 (src1[0],  src2[0],  set,  ALU_control[3], ALU_control[2], minus,          ALU_control[1:0], resultTemp[0],  carryTemp[0]);

genvar i;
generate
    for(i = 1; i < 31; i = i + 1) begin : aluUnit
        alu_top  aluUnit(src1[i],  src2[i],  1'b0, ALU_control[3], ALU_control[2], carryTemp[i-1], ALU_control[1:0], resultTemp[i],  carryTemp[i]);
    end
endgenerate 
alu_bottom aluUnit31(src1[31], src2[31], 1'b0, ALU_control[3], ALU_control[2], carryTemp[30],  ALU_control[1:0], resultTemp[31], carryTemp[31], set);

                
always@( posedge clk or negedge rst_n ) 
begin
    if (!rst_n) begin
        result = 32'b0;
    end
    else 
    begin
        result[32-1:0] = resultTemp[32-1:0];

        if (ALU_control[1:0] == 2'b10)  //add or sub mode
            cout = carryTemp[31];
        else
            cout = 0;
        
        overflow = carryTemp[31] ^ carryTemp[30];
        
        if(result == 32'b0)
            zero = 1;
        else
            zero = 0;
    end
end
endmodule