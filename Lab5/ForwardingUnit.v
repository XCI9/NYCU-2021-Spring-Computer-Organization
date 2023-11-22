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

module ForwardingUnit(
    RegWrite_MEM_i,
    RDaddr_MEM_i,
    RegWrite_WB_i,
    RDaddr_WB_i,
    RSaddr_EX_i,
    RTaddr_EX_i,
    ALUSrc1Forward_o,
    ALUSrc2Forward_o
    );
     
//I/O ports
input          RegWrite_MEM_i;
input  [5-1:0] RDaddr_MEM_i;
input          RegWrite_WB_i;
input  [5-1:0] RDaddr_WB_i;
input  [5-1:0] RSaddr_EX_i;
input  [5-1:0] RTaddr_EX_i;

output [2-1:0] ALUSrc1Forward_o;
output [2-1:0] ALUSrc2Forward_o;
//0 => no forwarding
//1 => MEM forwarding
//2 => WB forwarding

//Internal Signals
reg [2-1:0] ALUSrc1Forward_o;
reg [2-1:0] ALUSrc2Forward_o;
//Parameter

//Main function
always @(*) begin
//ALUSrc1Forward_o
    if      (RegWrite_MEM_i && RSaddr_EX_i == RDaddr_MEM_i && RDaddr_MEM_i != 0) ALUSrc1Forward_o <= 2'b01;
    else if (RegWrite_WB_i  && RSaddr_EX_i == RDaddr_WB_i  && RDaddr_WB_i != 0)  ALUSrc1Forward_o <= 2'b10;
    else                                                                         ALUSrc1Forward_o <= 2'b00;


//ALUSrc2Forward_o
    if      (RegWrite_MEM_i && RTaddr_EX_i == RDaddr_MEM_i && RDaddr_MEM_i != 0) ALUSrc2Forward_o <= 2'b01;
    else if (RegWrite_WB_i  && RTaddr_EX_i == RDaddr_WB_i  && RDaddr_WB_i != 0)  ALUSrc2Forward_o <= 2'b10;
    else                                                                         ALUSrc2Forward_o <= 2'b00;

	
end


endmodule





                    
                    