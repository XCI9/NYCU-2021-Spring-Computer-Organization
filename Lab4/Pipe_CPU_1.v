`timescale 1ns / 1ps
//studentID: 109550094
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] pc_in;
wire [32-1:0] pc_out;
wire [32-1:0] pc_out_add4_IF;
wire [32-1:0] instruction_IF;

/**** ID stage ****/
wire [32-1:0] pc_out_add4_ID;
wire [32-1:0] instruction_ID;

wire [6-1:0] opcode;
wire [5-1:0] RSaddr;
wire [5-1:0] RTaddr;
wire [5-1:0] RDaddrSelect1_ID;
wire [5-1:0] RDaddrSelect2_ID;
wire [16-1:0] addr;
//

assign opcode = instruction_ID[31:26];
assign RSaddr = instruction_ID[25:21];
assign RTaddr = instruction_ID[20:16];
assign RDaddrSelect1_ID = instruction_ID[20:16];
assign RDaddrSelect2_ID = instruction_ID[15:11];
assign addr = instruction_ID[15:0];
//assign funct = instrction[5:0];

wire [32-1:0] AddrExtended_ID;
wire [32-1:0] RSdata_ID;
wire [32-1:0] RTdata_ID;

//control signal
wire RegWrite_ID;
wire [3-1:0] ALU_op_ID;   
wire ALUSrc_ID;   
wire RegDst_ID;   
wire Branch_ID; 
wire MemRead_ID;
wire MemWrite_ID;
wire MemtoReg_ID;


/**** EX stage ****/
wire [32-1:0] pc_out_add4_EX;
wire [5-1:0] RDaddrSelect1_EX;
wire [5-1:0] RDaddrSelect2_EX;


wire [32-1:0] AddrExtended_EX;
wire [6-1:0] funct;
assign funct = AddrExtended_EX[5:0];
wire [32-1:0] RSdata_EX;
wire [32-1:0] RTdata_EX;

wire [32-1:0] ALUin2;
wire [4-1:0] ALUCtrl; 
wire [32-1:0] AddrShift2;


wire [32-1:0] ALUResult_EX;
wire [32-1:0] BeqSrc1_EX;
wire [5-1:0]  RDaddr_EX;


//control signal
wire zero_EX;

wire RegWrite_EX;
wire [3-1:0] ALU_op_EX;   
wire ALUSrc_EX;   
wire RegDst_EX;   
wire Branch_EX; 
wire MemRead_EX;
wire MemWrite_EX;
wire MemtoReg_EX;


/**** MEM stage ****/
wire [32-1:0] ALUResult_MEM;
wire [32-1:0] BeqSrc1_MEM;
wire [32-1:0] RTdata_MEM;
wire [5-1:0]  RDaddr_MEM;

wire [32-1:0] MemData_MEM;

//control signal
wire zero_MEM;

wire RegWrite_MEM;     
wire Branch_MEM; 
wire MemRead_MEM;
wire MemWrite_MEM;
wire MemtoReg_MEM;


/**** WB stage ****/
wire [32-1:0] ALUResult_WB;
wire [32-1:0] MemData_WB;
wire [5-1:0]  RDaddr_WB;

wire [32-1:0] RDdata;


//control signal
wire RegWrite_WB;     
wire MemtoReg_WB;



/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
    .data0_i(pc_out_add4_IF),
    .data1_i(BeqSrc1_MEM),
    .select_i(Branch_MEM & zero_MEM),
    .data_o(pc_in)
);

ProgramCounter PC(
    .clk_i(clk_i),      
    .rst_i (rst_i),     
    .pc_in_i(pc_in),   
    .pc_out_o(pc_out)

);

Instruction_Memory IM(
    .addr_i(pc_out),
    .instr_o(instruction_IF)
);
			
Adder Add_pc(
    .src1_i(4),     
    .src2_i(pc_out),     
    .sum_o(pc_out_add4_IF)
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .data_i({pc_out_add4_IF, instruction_IF}),
    .data_o({pc_out_add4_ID, instruction_ID})
);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .RSaddr_i(RSaddr),  
    .RTaddr_i(RTaddr),  
    .RDaddr_i(RDaddr_WB),  
    .RDdata_i(RDdata), 
    .RegWrite_i(RegWrite_WB),
    .RSdata_o(RSdata_ID),  
    .RTdata_o(RTdata_ID) 
);

Decoder Control(
    .instr_op_i(opcode),
    .RegWrite_o(RegWrite_ID), 
    .ALU_op_o(ALU_op_ID),   
    .ALUSrc_o(ALUSrc_ID),   
    .RegDst_o(RegDst_ID),   
    .Branch_o(Branch_ID),
    .MemRead_o(MemRead_ID), 
    .MemWrite_o(MemWrite_ID), 
    .MemtoReg_o(MemtoReg_ID)
);

Sign_Extend Sign_Extend(
    .data_i(addr),
    .data_o(AddrExtended_ID)
);	

Pipe_Reg #(.size(148)) ID_EX(
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .data_i({RegWrite_ID, MemtoReg_ID, MemRead_ID, MemWrite_ID, Branch_ID, ALUSrc_ID, ALU_op_ID, RegDst_ID, pc_out_add4_ID, RSdata_ID, RTdata_ID, AddrExtended_ID, RDaddrSelect1_ID, RDaddrSelect2_ID}),
    .data_o({RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, Branch_EX, ALUSrc_EX, ALU_op_EX, RegDst_EX, pc_out_add4_EX, RSdata_EX, RTdata_EX, AddrExtended_EX, RDaddrSelect1_EX, RDaddrSelect2_EX})
);


//Instantiate the components in EX stage	   
MUX_2to1 #(.size(32)) Mux1(
    .data0_i(RTdata_EX),
    .data1_i(AddrExtended_EX),
    .select_i(ALUSrc_EX),
    .data_o(ALUin2)
);

ALU ALU(
    .src1_i(RSdata_EX),
	.src2_i(ALUin2),
	.ctrl_i(ALUCtrl),
	.result_o(ALUResult_EX),
	.zero_o(zero_EX)
);
		
ALU_Ctrl ALU_Ctrl(
    .funct_i(funct),   
    .ALUOp_i(ALU_op_EX),   
    .ALUCtrl_o(ALUCtrl)
);


Shift_Left_Two_32 Shifter(
    .data_i(AddrExtended_EX),
    .data_o(AddrShift2)
);

Adder Add_pc_branch(
    .src1_i(pc_out_add4_EX),     
    .src2_i(AddrShift2),     
    .sum_o(BeqSrc1_EX)
);


MUX_2to1 #(.size(5)) Mux2(
    .data0_i(RDaddrSelect1_EX),
    .data1_i(RDaddrSelect2_EX),
    .select_i(RegDst_EX),
    .data_o(RDaddr_EX)
);

Pipe_Reg #(.size(107)) EX_MEM(
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .data_i({RegWrite_EX,  MemtoReg_EX,  MemRead_EX,  MemWrite_EX,  Branch_EX,  BeqSrc1_EX,  zero_EX,  ALUResult_EX,  RTdata_EX,  RDaddr_EX}),
    .data_o({RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM, Branch_MEM, BeqSrc1_MEM, zero_MEM, ALUResult_MEM, RTdata_MEM, RDaddr_MEM})
);


//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(ALUResult_MEM),
    .data_i(RTdata_MEM),
    .MemRead_i(MemRead_MEM),
    .MemWrite_i(MemWrite_MEM),
    .data_o(MemData_MEM)
);

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .data_i({RegWrite_MEM, MemtoReg_MEM, ALUResult_MEM, MemData_MEM, RDaddr_MEM}),
    .data_o({RegWrite_WB,  MemtoReg_WB,  ALUResult_WB,  MemData_WB,  RDaddr_WB})
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i(ALUResult_WB),
    .data1_i(MemData_WB),
    .select_i(MemtoReg_WB),
    .data_o(RDdata)
);

/****************************************
signal assignment
****************************************/

endmodule

