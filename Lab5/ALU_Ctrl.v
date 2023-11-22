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

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*)begin
    case (ALUOp_i)
        3'b000: //R-format
            begin
                case (funct_i)
                    6'b100000: ALUCtrl_o <= 4'b0010;//add
                    6'b100010: ALUCtrl_o <= 4'b0110;//sub
                    6'b100100: ALUCtrl_o <= 4'b0000;//and
                    6'b100101: ALUCtrl_o <= 4'b0001;//or
                    6'b101010: ALUCtrl_o <= 4'b0111;//slt
                    6'b011000: ALUCtrl_o <= 4'b0011;//mult
                endcase
            end
        3'b001: ALUCtrl_o <= 4'b0010;//addi
        3'b010: ALUCtrl_o <= 4'b0111;//slti
        3'b100: ALUCtrl_o <= 4'b0110;//beq
        3'b011: ALUCtrl_o <= 4'b0010;//lw
        3'b101: ALUCtrl_o <= 4'b0010;//sw
    endcase
end


endmodule     





                    
                    