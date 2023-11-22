//studentID: 109550094
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
	stall_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
	Beq_o,
	Bgt_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;
input          stall_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         Beq_o;
output         Bgt_o;
output         MemRead_o;
output         MemWrite_o;
output         MemtoReg_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            Beq_o;
reg            Bgt_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            MemtoReg_o;

//Parameter

//Main function
always @(*) begin
	if (stall_i)    begin RegWrite_o <= 1'b0; ALU_op_o <= 3'b000; ALUSrc_o <= 0; RegDst_o <= 1'b0; end
	else begin
		case (instr_op_i)
		6'b000000:	begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b000; ALUSrc_o <= 0; RegDst_o <= 1'b1; end//R-format
		6'b001000:	begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b001; ALUSrc_o <= 1; RegDst_o <= 1'b0; end//addi
		6'b001010:	begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b010; ALUSrc_o <= 1; RegDst_o <= 1'b0; end//slti
		
		6'b000100,	                                                                                  //beq
		6'b000101,	                                                                                  //bne
		6'b000001,	                                                                                  //bge
		6'b000111:	begin RegWrite_o <= 1'b0; ALU_op_o <= 3'b100; ALUSrc_o <= 0; RegDst_o <= 1'bx; end//bgt

		6'b100011:  begin RegWrite_o <= 1'b1; ALU_op_o <= 3'b011; ALUSrc_o <= 1; RegDst_o <= 1'b0; end//lw
    	6'b101011:  begin RegWrite_o <= 1'b0; ALU_op_o <= 3'b101; ALUSrc_o <= 1; RegDst_o <= 1'bx; end//sw
	endcase
	end
end

always @(*) begin
	if (stall_i)    begin MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0;end
	else begin
		case (instr_op_i)
		6'b000000:	begin MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0;end//R-fromat
		6'b001000:	begin MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0;end//addi
		6'b001010:	begin MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'b0;end//slti
		
		6'b000100,                                                                    //beq
		6'b000101,                                                                    //bne
        6'b000001,                                                                    //bge
        6'b000111:	begin MemRead_o <= 1'b0; MemWrite_o <= 1'b0; MemtoReg_o = 1'bx;end//bgt


		6'b100011:  begin MemRead_o <= 1'b1; MemWrite_o <= 1'b0; MemtoReg_o = 1'b1;end//lw
    	6'b101011:  begin MemRead_o <= 1'b0; MemWrite_o <= 1'b1; MemtoReg_o = 1'bx;end//sw
		endcase
	end
end

always @(*) begin
	if (stall_i)       begin Branch_o <= 1'b0; Beq_o <= 1'bx; Bgt_o <= 1'bx; end
	else begin
		case (instr_op_i)
    	    6'b000100: begin Branch_o <= 1'b1; Beq_o <= 1'b1; Bgt_o <= 1'b0; end//beq
			6'b000101: begin Branch_o <= 1'b1; Beq_o <= 1'b0; Bgt_o <= 1'b0; end//bne
    	    6'b000001: begin Branch_o <= 1'b1; Beq_o <= 1'b1; Bgt_o <= 1'b1; end//bge
    	    6'b000111: begin Branch_o <= 1'b1; Beq_o <= 1'b0; Bgt_o <= 1'b1; end//bgt
			default:   begin Branch_o <= 1'b0; Beq_o <= 1'bx; Bgt_o <= 1'bx; end
		endcase
	end
end



endmodule





                    
                    