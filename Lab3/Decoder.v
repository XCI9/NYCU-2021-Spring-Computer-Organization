//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    instr_funct_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    Jump_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o,
    Jal_o,
    JumpRegister_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] instr_funct_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         Jump_o;
output		   MemRead_o;
output         MemWrite_o;
output		   MemtoReg_o;
output         Jal_o;
output         JumpRegister_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            Jump_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            MemtoReg_o;
reg            Jal_o;
reg            JumpRegister_o;

//Parameter

//Main function
always @(*) begin
	case (instr_op_i)
	6'b000000:	begin case(instr_funct_i)
                    6'b001000: begin
                      RegWrite_o <= 1'b0; ALU_op_o <= 3'b000; ALUSrc_o <= 0; RegDst_o <= 1'b0; Branch_o <= 1'b0; end//jr
                    6'b000000: begin
                      RegWrite_o <= 1'b0; ALU_op_o <= 3'b000; ALUSrc_o <= 0; RegDst_o <= 1'b0; Branch_o <= 1'b0; end//nop
                    default: begin   
                      RegWrite_o <= 1'b1; ALU_op_o <= 3'b000; ALUSrc_o <= 0; RegDst_o <= 1'b1; Branch_o <= 1'b0; end//R-format
                endcase end
	6'b001000:	begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b001; ALUSrc_o <= 1; RegDst_o <= 1'b0; Branch_o <= 1'b0; end//addi
	6'b001010:	begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b010; ALUSrc_o <= 1; RegDst_o <= 1'b0; Branch_o <= 1'b0; end//slti
	6'b000100:	begin RegWrite_o <= 1'b0; ALU_op_o <= 3'b100; ALUSrc_o <= 0; RegDst_o <= 1'bx; Branch_o <= 1'b1; end//beq

	6'b100011:  begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b011; ALUSrc_o <= 1; RegDst_o <= 1'b0; Branch_o <= 1'b0; end//lw
    6'b101011:  begin RegWrite_o <= 1'b0; ALU_op_o <= 3'b101; ALUSrc_o <= 1; RegDst_o <= 1'bx; Branch_o <= 1'b0; end//sw
    6'b000010:  begin RegWrite_o <= 1'b0; ALU_op_o <= 3'b110; ALUSrc_o <= 0; RegDst_o <= 1'bx; Branch_o <= 1'b0; end//jump
    6'b000011:  begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b111; ALUSrc_o <= 0; RegDst_o <= 1'bx; Branch_o <= 1'b0; end//jal
	endcase
end

always @(*) begin
	case (instr_op_i)
	6'b000000:	begin 
                case(instr_funct_i)
                    6'b001000: begin
                      Jump_o <= 1'b0; MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0; Jal_o <= 1'b0; JumpRegister_o <= 1'b1;end//jr
                    default: begin
                      Jump_o <= 1'b0; MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0; Jal_o <= 1'b0; JumpRegister_o <= 1'b0;end//R-fromat
                endcase end
	6'b001000:	begin Jump_o <= 1'b0; MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0; Jal_o <= 1'b0; JumpRegister_o <= 1'b0;end//addi
	6'b001010:	begin Jump_o <= 1'b0; MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0; Jal_o <= 1'b0; JumpRegister_o <= 1'b0;end//slti
	6'b000100:	begin Jump_o <= 1'b0; MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'bx; Jal_o <= 1'b0; JumpRegister_o <= 1'b0;end//beq

	6'b100011:  begin Jump_o <= 1'b0; MemRead_o <= 1'b1; MemWrite_o <= 1'b0; MemtoReg_o = 1'b1; Jal_o <= 1'b0; JumpRegister_o <= 1'b0;end//lw
    6'b101011:  begin Jump_o <= 1'b0; MemRead_o <= 1'b0; MemWrite_o <= 1'b1; MemtoReg_o = 1'bx; Jal_o <= 1'b0; JumpRegister_o <= 1'b0;end//sw
    6'b000010:  begin Jump_o <= 1'b1; MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'bx; Jal_o <= 1'b0; JumpRegister_o <= 1'b0;end//jump
    6'b000011:  begin Jump_o <= 1'b1; MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0; Jal_o <= 1'b1; JumpRegister_o <= 1'b0;end//jal
	endcase
end


endmodule





                    
                    