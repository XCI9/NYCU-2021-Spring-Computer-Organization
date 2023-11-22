# Lab 1: 32-bit ALU

## Goal
The goal of this LAB is to implement a 32-bit ALU (Arithmetic Logic Unit). ALU is the basic computing component of a CPU. Its operations include AND, OR, addition, subtraction, etc. 
This LAB will help you understand the CPU architecture. LAB 1 will be reused; you will use this module in later LABs. The function of testbench is to read input data automatically and 
output erroneous data. Please unzip the files in the same folder. 
## Homework Requirement
1. Please use Xilinx Vivado or ModelSim as your HDL simulator. (Xilinx Vivado is preferred) 
2. Please **attach student IDs as comments** at the top of each file. 
3. Please zip the archive and **name it as "ID.zip"** (e.g., 109XXXXX.zip) before uploading to e3 
4. Testbench module is provided. 
5. **Any work by fraud will absolutely get a zero point.** 
6. The names of top module and IO ports must be named as follows:
      - Top module: alu.v
      ```verilog
      module alu( 
      clk, // system clock (input) rst_n, 
      // negative reset (input) 
      src1, // 32 bits source 1 (input) 
      src2, // 32 bits source 2 (input) 
      ALU_control, // 4 bits ALU control input (input) 
      result, // 32 bits result(output) 
      zero, // 1 bit when the output is 0, zero must be set (output) 
      cout, // 1 bit carry out (output) 
      overflow // 1 bit overflow(output) 
      ); 
      ```
      - ALU starts to work when the signal rst_n is 1, and then catches the data from src1 and src2. 
      - In order to have a good coding style, please obey the rules below: 
        - One module in one file. 
        - Module name and file name must be the same. 
      - For example: The file "alu.v" only contains the module "alu".
7. **instruction set: basic operation instruction (60%)**
   |ALU Action|Name          |ALU Control Input|
   |:--------:|:------------:|:---------------:|
   |And       | And          |0000             |
   |Or        | Or           |0001             |
   |Add       | Addition     |0010             |
   |Sub       | Subtraction  |0110             |
   |Nor       | Nor          |1100             |
   |Slt       | Set less than|0111             |
9. **zcv three control signal: zero, carry out, overflow (30%)**
        1. “zero” must be set when the result is 0. 
        2. “cout” must be set when there is a carry out. 
        3. “overflow” must be set when overflow. 
        Only "add" and "sub" operations need to handle carry out and overflow flag
10. About alu_top.v
        - alu_top.v is an 1-bit ALU module. We don’t force you to use alu_top.v to implement this homework. However, we still strongly recommend that you implement this 
homework by using alu_top.v like the architecture diagram below. The design will become more complex in the following homework, so implementing your design by 
connecting multiple modules is an essential skill.
        - **Note: You can add any module into your design if you want, but the top module must be alu in the alu.v defined in section f.**

## Architecture Diagram
![image](https://github.com/XCI9/NYCU-2021-Spring-Computer-Organization/assets/71249961/ca470230-632e-430e-96fc-e50de304dd57)

## Grade 
1. Total:100 points (hidden cases will be evaluated) 
2. Report: 10 points 
3. Late submission: Score * 0.8 before 4/11. After 4/11, you will get 0. 
4. Format: Put all your design sources(alu.v and alu_top.v in this lab) into **one directory named “your_student_id” and zip the directory named “your_student_id.zip”. You only need to submit 
“your_student_id.zip”.** If your submission doesn’t meet the required format, you’ll **get 10 points punishment.** 
5. Plagiarism will get 0 point
   Please add all the .txt files into the project (please refer to section 5), after simulation finishes, 
you will get some information.
```
Simulator is doing circuit initialization process.
Finished circuit initialzation process.
***************************************************
 Congratulation! All data are correct!
***************************************************
```
