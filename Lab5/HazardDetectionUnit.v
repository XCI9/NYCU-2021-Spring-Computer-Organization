//studentID: 109550094
//Subject:     CO project 2 - HazardDetectionUnit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module HazardDetectionUnit(
    MemRead_EX_i,
    RTaddr_ID_i,
    RTdata_ID_i,
    RSaddr_ID_i,
    RSdata_ID_i,
    RTaddr_EX_i,
    Branch_i,
    Stall_o,
    IF_Flush_o
    );
     
//I/O ports
input           MemRead_EX_i;
input  [5-1:0]  RTaddr_ID_i;
input  [32-1:0] RTdata_ID_i;
input  [5-1:0]  RSaddr_ID_i;
input  [32-1:0] RSdata_ID_i;
input  [5-1:0]  RTaddr_EX_i;
input           Branch_i;

 
output          Stall_o;
output          IF_Flush_o;

//Internal Signals
reg        Stall_o;
reg        IF_Flush_o;
//Parameter

//Main function
always @(*) begin
	if      (MemRead_EX_i && RTaddr_ID_i == RTaddr_EX_i) begin Stall_o <= 1; IF_Flush_o <= 0; end //load-use
    else if (MemRead_EX_i && RSaddr_ID_i == RTaddr_EX_i) begin Stall_o <= 1; IF_Flush_o <= 0; end //load-use
    else if (Branch_i)                                   begin Stall_o <= 0; IF_Flush_o <= 1; end //branch
    else                                                 begin Stall_o <= 0; IF_Flush_o <= 0; end
end

endmodule





                    
                    