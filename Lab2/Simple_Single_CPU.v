//studentID: 109550094
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input      clk_i;
input      rst_i;

//Internal Signles
wire [32-1:0] pc_in;
wire [32-1:0] pc_out;
wire [32-1:0] pc_out_add4;

wire [32-1:0] instrction;
wire [6-1:0] opcode;
wire [5-1:0] RSaddr;
wire [5-1:0] RTaddr;
wire [5-1:0] RDaddrSelect;
wire [16-1:0] addr;
wire [6-1:0] funct;
//assign opcode = instrction != 0 ? instrction[31:26] : 6'bxxxxxx;
//assign RSaddr = instrction != 0 ? instrction[25:21] : 6'bxxxxxx;
//assign RTaddr = instrction != 0 ? instrction[20:16] : 6'bxxxxxx;
//assign RDaddrSelect = instrction != 0 ? instrction[15:11] : 6'bxxxxxx;
//assign addr = instrction != 0 ? instrction[15:0] : 6'bxxxxxx;
//assign funct = instrction != 0 ? instrction[5:0] : 6'bxxxxxx;
assign opcode = instrction[31:26];
assign RSaddr = instrction[25:21];
assign RTaddr = instrction[20:16];
assign RDaddrSelect = instrction[15:11];
assign addr = instrction[15:0];
assign funct = instrction[5:0];

wire [5-1:0]  RDaddr;
wire [32-1:0] RDdata;
wire RegWrite;
wire [3-1:0] ALU_op;   
wire ALUSrc;   
wire RegDst;   
wire Branch; 
wire [4-1:0] ALUCtrl;
wire zero;
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;
wire [32-1:0] AddrExtended;
wire [32-1:0] ALUin2;
wire [32-1:0] AddrShift2;
wire [32-1:0] Mux_PC_Source1;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
	.pc_in_i(pc_in),   
	.pc_out_o(pc_out) 
	);
	
Adder Adder1(
        .src1_i(pc_out),     
	.src2_i(4),     
	.sum_o(pc_out_add4)    
	);
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	.instr_o(instrction)    
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(RTaddr),
        .data1_i(RDaddrSelect),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
        .RSaddr_i(RSaddr),  
        .RTaddr_i(RTaddr),  
        .RDaddr_i(RDaddr),  
        .RDdata_i(RDdata), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(opcode), 
	.RegWrite_o(RegWrite), 
	.ALU_op_o(ALU_op),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),   
	.Branch_o(Branch)   
	);

ALU_Ctrl AC(
        .funct_i(funct),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(addr),
        .data_o(AddrExtended)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(AddrExtended),
        .select_i(ALUSrc),
        .data_o(ALUin2)
        );	
		
ALU ALU(
        .src1_i(RSdata),
	.src2_i(ALUin2),
	.ctrl_i(ALUCtrl),
	.result_o(RDdata),
	.zero_o(zero)
	);
		
Adder Adder2(
        .src1_i(pc_out_add4),     
	.src2_i(AddrShift2),     
	.sum_o(Mux_PC_Source1)      
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(AddrExtended),
        .data_o(AddrShift2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_out_add4),
        .data1_i(Mux_PC_Source1),
        .select_i(Branch & zero),
        .data_o(pc_in)
        );	

endmodule
		  


