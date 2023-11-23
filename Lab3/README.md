# Lab 3: Single Cycle CPU - Complete Edition 

## Goal
Based on Lab 2, you need to add a memory unit and implement a complete single cycle CPU that can run R-type, I-type and jump instructions. 

## Homework Requirement
1. Please use Vivado as your HDL simulator(if the execution result in your environment is different from ours, you need to bring your laptop to the lab and demo it to us).
2. Please **attach student IDs as comments** at the top of each file. <br/>
   The file type of your report should be PDF.
3. Please add the files listed below into one directory named "your_student_id", and zip it as " your_student_id.zip". <br/>
The file structure in this lab should be (for example, id=109550094):
```bash
109550094/
├── Adder.v
├── ALU_Ctrl.v
├── ALU.v
├── Decoder.v
├── MUX_2to1
├── report_109550094.pdf
├── Shift_Left_Two_32.v
├── Sign_Extend.v
└── Simple_Single_CPU.v
```
4. Please **do not add unnecessary or given files and folders** (like .DS_Store, __MACOSX).
5. Program Counter, Instruction Memory, Data Memory, Register File and Testbench are supplied. (don’t need to modify these files).
6. REGISTER_BANK [29] represents the stack pointer register value (initially 128). Other registers are initialized to 0.
7. You may add more control signals to the decoder:
    1. Branch_o
    2. Jump_o
    3. MemRead_o
    4. MemWrite_o
    5. MemtoReg_o


8. **Basic Instructions: the following instructions have to be executed correctly in your CPU design, and we may use some hidden cases to further evaluate your 
design (40%).**<br/>
(For those who can't read testcase txt files after adding the testcase into simulation sources, please change the relative path in instr_memory file to absolute path.) <br/>
**Your CPU design has to support the instruction set from Lab 2 + the following instructions:**
    1. lw (load word): Reg[Rt] ← Mem[Rs+Imm]
      ```
      ┌────────────┬─────────┬─────────┬────────────────────────────────┐
      │ 6’b100011  │Rs[25:21]│Rt[20:16]│          Imm[15:0]             │
      └────────────┴─────────┴─────────┴────────────────────────────────┘
      ```
    2. sw (store word):  Mem[Rs+Imm] ← Reg[Rt]
      ```
      ┌────────────┬─────────┬─────────┬────────────────────────────────┐
      │ 6’b101011  │Rs[25:21]│Rt[20:16]│          Imm[15:0]             │
      └────────────┴─────────┴─────────┴────────────────────────────────┘
      ```
    3. jump: PC ← { PC[31:28], address<<2 }
      ```
      ┌────────────┬────────────────────────────────────────────────────┐
      │ 6’b000010  │                    Imm[15:0]                       │
      └────────────┴────────────────────────────────────────────────────┘
      ```
9. **Advanced Instructions: the following instructions have to be executed correctly in your CPU design, and we may use some hidden cases to further evaluate your design (40%).**
    1. jal (jump and link)<br/>
       In MIPS, the 31th register saves return address for function calls.<br/>
       Reg[31] ← PC+4<br/>
       PC ← { PC[31:28], address<<2 }
       ```
       ┌────────────┬────────────────────────────────────────────────────┐
       │ 6’b000010  │                    Imm[15:0]                       │
       └────────────┴────────────────────────────────────────────────────┘
       ```
    3. jr (jump register)<br/>
       In MIPS, you can use `jr r31` to jump to the return address linked from `jal` instruction.<br/>
       PC ← Reg[Rs]
       ```
       ┌────────────┬─────────┬─────────┬─────────┬─────────┬────────────┐
       │ 6’b000000  │Rs[25:21]│    0    │    0    │    0    │ 6’b001000  │
       └────────────┴─────────┴─────────┴─────────┴─────────┴────────────┘
       ```
10. Test program
    The second testbench CO_P3_test_data2.txt is a Fibonacci function. r2 represent the final answer. Please refer to **test2.txt**.

## Architecture Diagram
This is a reference design. **You need to modify this design to meet the requirements.**
![image](https://github.com/XCI9/NYCU-2021-Spring-Computer-Organization/assets/71249961/ae15c8bd-b5d9-47fe-bb8e-cfba175b7380)

## Report
1. Architecture Diagram
2. Hardware Module Analysis
3. Finished part
4. Problems you met and solutions
5. Summary

## Grade
1. Total: 100 points (plagiarism will get 0 point)
  - Report: 20 points (please use pdf format)
  - Hardware design: 80 points
2. Late submission: Score * 0.8 before 5/30. After 5/30, you will get 0.
3. Wrong format: 10 points punishment

## Q&A
If you have any question, it is recommended to ask in the Facebook discussion forum.
