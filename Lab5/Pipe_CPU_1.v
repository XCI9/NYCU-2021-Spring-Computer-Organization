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
wire [5-1:0] RSaddr_ID;
wire [5-1:0] RTaddr_ID;
wire [5-1:0] RDaddrSelect1_ID;
wire [5-1:0] RDaddrSelect2_ID;
wire [16-1:0] addr;
wire [32-1:0] BranchSrc_ID;

assign opcode = instruction_ID[31:26];
assign RSaddr_ID = instruction_ID[25:21];
assign RTaddr_ID = instruction_ID[20:16];
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
wire Beq_ID;
wire Bgt_ID; 
wire MemRead_ID;
wire MemWrite_ID;
wire MemtoReg_ID;

wire BranchDetect;


/**** EX stage ****/
wire [5-1:0] RDaddrSelect1_EX;
wire [5-1:0] RDaddrSelect2_EX;
wire [5-1:0] RSaddr_EX;
wire [5-1:0] RTaddr_EX;
wire [32-1:0] BranchSrc_EX;

wire [32-1:0] AddrExtended_EX;
wire [6-1:0] funct;
assign funct = AddrExtended_EX[5:0];
wire [32-1:0] RSdata_EX;
wire [32-1:0] RTdata_EX;

wire [32-1:0] ALUSrc1;
wire [32-1:0] ALUSrc2;
wire [32-1:0] ALUSrc2Temp;
wire [4-1:0] ALUCtrl; 
wire [32-1:0] AddrShift2;


wire [32-1:0] ALUResult_EX;
wire [5-1:0]  RDaddr_EX;


//control signal
wire zero_EX;

wire RegWrite_EX;
wire [3-1:0] ALU_op_EX;   
wire ALUSrc_EX;   
wire RegDst_EX;   
wire MemRead_EX;
wire MemWrite_EX;
wire MemtoReg_EX;


/**** MEM stage ****/
wire [32-1:0] ALUResult_MEM;
wire [32-1:0] RTdata_MEM;
wire [5-1:0]  RDaddr_MEM;

wire [32-1:0] MemData_MEM;

//control signal
wire zero_MEM;

wire RegWrite_MEM;     
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

/**** hazard ****/
wire stall;

wire  IF_Flush;

/**** forwarding ****/
wire  [2-1:0] ALUSrc1Forwarding;
wire  [2-1:0] ALUSrc2Forwarding;
/****************************************
Instantiate modules
****************************************/
//hazard
 HazardDetectionUnit  HazardDetection(
    .MemRead_EX_i(MemRead_EX),
    .RTaddr_ID_i(RTaddr_ID),
    .RTdata_ID_i(RTdata_ID),
    .RSaddr_ID_i(RSaddr_ID),
    .RSdata_ID_i(RSdata_ID),
    .RTaddr_EX_i(RTaddr_EX),
    .Branch_i(BranchDetect),
    .Stall_o(stall),
    .IF_Flush_o(IF_Flush)
 );


 //forwarding
 ForwardingUnit Forwarding(
    .RegWrite_MEM_i(RegWrite_MEM),
    .RDaddr_MEM_i(RDaddr_MEM),
    .RegWrite_WB_i(RegWrite_WB),
    .RDaddr_WB_i(RDaddr_WB),
    .RSaddr_EX_i(RSaddr_EX),
    .RTaddr_EX_i(RTaddr_EX),
    .ALUSrc1Forward_o(ALUSrc1Forwarding),
    .ALUSrc2Forward_o(ALUSrc2Forwarding)
 );


//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
    .data0_i(pc_out_add4_IF),
    .data1_i(BranchSrc_EX),
    .select_i(BranchDetect),
    .data_o(pc_in)
);

ProgramCounter PC(
    .stall_i(stall),
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
    .stall_i(stall),
    .flush_i(1'b0),
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .data_i(IF_Flush ? 32'b0 : {pc_out_add4_IF, instruction_IF}),
    .data_o({pc_out_add4_ID, instruction_ID})
);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .RSaddr_i(RSaddr_ID),  
    .RTaddr_i(RTaddr_ID),  
    .RDaddr_i(RDaddr_WB),  
    .RDdata_i(RDdata), 
    .RegWrite_i(RegWrite_WB),
    .RSdata_o(RSdata_ID),  
    .RTdata_o(RTdata_ID) 
);

Decoder Control(
    .instr_op_i(opcode),
    .stall_i(stall | IF_Flush),
    .RegWrite_o(RegWrite_ID), 
    .ALU_op_o(ALU_op_ID),   
    .ALUSrc_o(ALUSrc_ID),   
    .RegDst_o(RegDst_ID),   
    .Branch_o(Branch_ID),
    .Beq_o(Beq_ID),
    .Bgt_o(Bgt_ID),
    .MemRead_o(MemRead_ID), 
    .MemWrite_o(MemWrite_ID), 
    .MemtoReg_o(MemtoReg_ID)
);

Sign_Extend Sign_Extend(
    .data_i(addr),
    .data_o(AddrExtended_ID)
);	

Shift_Left_Two_32 Shifter(
    .data_i(AddrExtended_ID),
    .data_o(AddrShift2)
);

Adder Add_pc_branch(
    .src1_i(pc_out_add4_ID),     
    .src2_i(AddrShift2),     
    .sum_o(BranchSrc_ID)
);

Pipe_Reg #(.size(160)) ID_EX(
    .stall_i(1'b0),
    .flush_i(1'b0),
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .data_i({RegWrite_ID, MemtoReg_ID, MemRead_ID, MemWrite_ID, ALUSrc_ID, ALU_op_ID, RegDst_ID, RSdata_ID, RTdata_ID, Branch_ID, Beq_ID, Bgt_ID, BranchSrc_ID, AddrExtended_ID, RDaddrSelect1_ID, RDaddrSelect2_ID, RSaddr_ID, RTaddr_ID}),
    .data_o({RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, ALUSrc_EX, ALU_op_EX, RegDst_EX, RSdata_EX, RTdata_EX, Branch_EX, Beq_EX, Bgt_EX, BranchSrc_EX, AddrExtended_EX, RDaddrSelect1_EX, RDaddrSelect2_EX, RSaddr_EX, RTaddr_EX})
);

//Instantiate the components in EX stage	   
MUX_2to1 #(.size(32)) Mux1(
    .data0_i(ALUSrc2Temp),
    .data1_i(AddrExtended_EX),
    .select_i(ALUSrc_EX),
    .data_o(ALUSrc2)
);



MUX_3to1 #(.size(32)) ALUSrc1ForwardingMux(
    .data0_i(RSdata_EX),
    .data1_i(ALUResult_MEM),
    .data2_i(RDdata),
    .select_i(ALUSrc1Forwarding),
    .data_o(ALUSrc1)
);

MUX_3to1 #(.size(32)) ALUSrc2ForwardingMux(
    .data0_i(RTdata_EX),
    .data1_i(ALUResult_MEM),
    .data2_i(RDdata),
    .select_i(ALUSrc2Forwarding),
    .data_o(ALUSrc2Temp)
);

Branch_Check Checker(
    .Branch_i(Branch_EX),
    .Beq_i(Beq_EX),
    .Bgt_i(Bgt_EX),
    .RSdata_i(ALUSrc1),
    .RTdata_i(ALUSrc2Temp),
    .Branch_o(BranchDetect)
);

ALU ALU(
    .src1_i(ALUSrc1),
	.src2_i(ALUSrc2),
	.ctrl_i(ALUCtrl),
	.result_o(ALUResult_EX),
	.zero_o(zero_EX)
);
		
ALU_Ctrl ALU_Ctrl(
    .funct_i(funct),   
    .ALUOp_i(ALU_op_EX),   
    .ALUCtrl_o(ALUCtrl)
);


MUX_2to1 #(.size(5)) Mux2(
    .data0_i(RDaddrSelect1_EX),
    .data1_i(RDaddrSelect2_EX),
    .select_i(RegDst_EX),
    .data_o(RDaddr_EX)
);

Pipe_Reg #(.size(74)) EX_MEM(
    .stall_i(1'b0),
    .flush_i(1'b0),
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .data_i({RegWrite_EX,  MemtoReg_EX,  MemRead_EX,  MemWrite_EX,  zero_EX,  ALUResult_EX,  ALUSrc2Temp, RDaddr_EX}),
    .data_o({RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM, zero_MEM, ALUResult_MEM, RTdata_MEM, RDaddr_MEM})
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
    .stall_i(1'b0),
    .flush_i(1'b0),
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

