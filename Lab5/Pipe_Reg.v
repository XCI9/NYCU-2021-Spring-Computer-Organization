`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    stall_i,
    flush_i,
    clk_i,
    rst_i,
    data_i,
    data_o
    );
					
parameter size = 0;

input   flush_i;
input   stall_i;
input   clk_i;		  
input   rst_i;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if (~stall_i)
        data_o <= data_i;
end

always@(posedge flush_i) begin
    data_o <= 0;

end

endmodule	