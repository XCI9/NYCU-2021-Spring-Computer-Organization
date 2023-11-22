# Lab 2: Single Cycle CPU - Simple Edition
**Due: 2021/5/2**
## Goal
Utilizing the ALU in Lab1 to implement a simple single cycle CPU (Not required. See Appendix.). CPU is the most important unit in computer system. Read the document 
carefully and do the lab, and you will have elementary knowledge of a MIPS CPU.

## Homework Requirement
1. Please use Vivado as your HDL simulator(if the execution result in your environment is different from ours, you need to bring your laptop to the lab and demo it to us).
2. Please **attach student IDs as comments** at the top of each file.
3. The file type of your report should be **PDF**.
4. Please add the files listed below into one directory named **"your_student_id"**, and **zip it as " your_student_id.zip"**.
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
5. Please **do not add unnecessary or given files**(like .txt, testbench.v, Instr_Memory.v, ProgramCounter.v, Reg_File.v) and folders (like .DS_Store, __MACOSX).
6. Program Counter, Instruction Memory, Register File and Testbench are given (don’t need to modify these files).
7. **Instruction set: the following instructions have to be executable in your CPU design, and we will use some hidden cases to further evaluate your design.**
8. **Any work by fraud will absolutely get 0 point.**

| Instruction |              Name              |     Example    |              Meaning              | Op <br>Field | Function <br>Field |
|:-----------:|:------------------------------:|:--------------:|-----------------------------------|:------------:|:------------------:|
|     add     |            Addition            |  add r1,r2,r3  |              r1=r2+r3             |       0      |      32 (0x20)     |
|     addi    |          Add Immediate         | addi r1,r2,100 |             r1=r2+100             |       0      |          0         |
|     sub     |           Subtraction          |  sub r1,r2,r3  |              r1=r2-r3             |       0      |      34 (0x22)     |
|     and     |            Logic AND           |  and r1,r2,r3  |              r1=r2&r3             |       0      |      36 (0x24)     |
|      or     |            Logic OR            |   or r1,r2,r3  |             r1=r2\|r3             |       0      |      37 (0x25)     |
|     slt     |        Set on Less Than        |  slt r1,r2,r3  | if(r2<r3) r1=1 <br>else      r1=0 |       0      |      42 (0x2a)     |
|     slti    | Set on Less Than <br>Immediate |  slti r1,r2,10 |    if(r2<10) r1=1 <br>else r1=0   | 10 <br>(0xa) |          0         |
|     beq     |         Branch on Equal        |  beq r1,r2,25  |    if(r1==r2)<br>goto PC+4+100    |       0      |          0         |

10. **If you don’t follow the architecture diagram, you’ll get 0 point.**

## Architecture Diagram
![image](https://github.com/XCI9/NYCU-2021-Spring-Computer-Organization/assets/71249961/ad195a8a-8af9-4a25-9907-7fc8b226b2c7)
Notice that every component in the diagram has a corresponding module(.v).

## Test
There are 2 test patterns, CO_P2_test_data1.txt, CO_P2_test_data2.txt. You need to add these two files as simulation sources. 
The default pattern is the first one. Please change the column 39 in the file “Instr_Memory.v” if you want to test another case: 
```
$readmemb("CO_P2_test_data1.txt", Instr_Mem)
```
The following are the assembly code for the test patterns: 
