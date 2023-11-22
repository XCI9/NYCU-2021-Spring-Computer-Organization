`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_bottom(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               set
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output reg    result;
output reg    cout;
output        set;


wire src1_temp, src2_temp;

reg andResult, orResult, addResult;

assign src1_temp =  A_invert ? ~src1 : src1;
assign src2_temp =  B_invert ? ~src2 : src2;
//assign src1_temp = (A_invert & (~src1)) | ((~A_invert) & src1);
//assign src2_temp = (B_invert & (~src2)) | ((~B_invert) & src2);

assign set = addResult;

always@(*)
begin
    andResult = src1_temp & src2_temp;
    orResult = src1_temp | src2_temp;
    {cout, addResult} = src1_temp + src2_temp + cin;

    case (operation)
    2'b00: result = andResult;
    2'b01: result = orResult;
    2'b10: result = addResult;
    2'b11: result = less;
    endcase
end

endmodule