//studentID: 109550094
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Branch_Check(
          Branch_i,
          Beq_i,
          Bgt_i,
          RSdata_i,
          RTdata_i,
          Branch_o
          );
          
//I/O ports 
input          Branch_i;
input          Beq_i;
input          Bgt_i;
input [32-1:0] RSdata_i;
input [32-1:0] RTdata_i;

output     Branch_o;    
     
//Internal Signals
reg        Branch_o;


//Parameter

       
//Select exact operation
always @(*)begin
    if(Branch_i) begin
        case ({Bgt_i,Beq_i})
            2'b00: Branch_o <= (RSdata_i != RTdata_i);  //bne
            2'b01: Branch_o <= (RSdata_i == RTdata_i);  //beq
            2'b10: Branch_o <= (RSdata_i >  RTdata_i) ? 1 : 0;  //bgt
            2'b11: Branch_o <= (RSdata_i >= RTdata_i);  //bge
        endcase
    end
    else Branch_o <= 0;
end


endmodule     





                    
                    