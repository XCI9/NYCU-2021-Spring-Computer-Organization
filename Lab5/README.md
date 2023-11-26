# Lab 3: Pipelined CPU

## Goal
Modify your Lab 4 CPU design, and implement an advanced pipelined CPU with (1) hazard detection and (2) data forwarding. 

## Homework Requirement
1. Please use Vivado as your HDL simulator(if the execution result in your environment is different from ours, you need to bring your laptop to the lab and demo it to us).
2. Please **attach student IDs as comments** at the top of each file. <br/>
   The file type of your report should be **PDF**.
3. Please add the files listed below into one directory named "your_student_id", and zip it as " your_student_id.zip". <br/>
The file structure in this lab should be (for example, id=109550094):
```bash
109550094/
├── report_109550094.pdf
└── (Any .v file that you need **except testbench.v**)
```
4. Please **do not add unnecessary or given files and folders** (like .DS_Store, __MACOSX).
5.  Instruction Memory, Data Memory, Pipe Reg, Reg File, Testbench are supplied. (don’t need to modify these files).
6. In the top module, please change N to the value which is total lengths of input signal (include data and control) of pipeline register.
   **Pipe_Reg #(.size(N)) ID_EX** 
   **(google verilog+parameter / parameterized modules / 參數式模組)**
8. **Your CPU needs to support the following instructions:**
    1. Basic Instructions: 
        1. ADD
        2. ADDI
        3. SUB
        4. AND
        5. OR
        6. SLT
        7. SLTI
        8. LW
        9. SW
        10. BEQ
        11. MULT
    2. Advanced Instructions
       
       |Instruction|   Op    |
       |:---------:|:-------:|
       |    BEQ    | 000 100 |
       |    BNE    | 000 101 |
       |    BGE    | 000 001 |
       |    BGT    | 000 111 |

      (Modify Hazard Detection Unit to flush useless pipeline registers (IF/ID, ID/EX, EX/MEM) if a branch launch)
   3. You must implement (1) Hazard Detection Unit and (2) Forwarding Unit.
   4. Your CPU needs to forward data if instructions have data dependency.
   5. Your CPU needs to stall pipelined CPU if it detects a load-use 


10. Testbench (“CO_P4_test_1.txt”):<br/>
Try to solve the date hazards in I1/I2, I5/I6, I8/I9, I9/I10 by using forwarding unit and Hazard Detection Unit.
    1.
    ```asm
    addi $1,$0,16 
    mult $2,$1,$1 
    addi $3,$0,8 
    sw $1,4($0) 
    lw $4,4($0) 
    sub $5,$4,$3 
    add $6,$3,$1 
    addi $7,$1,10 
    and $8,$7,$3 
    slt $9,$8,$7 
    ```
   Result: 
     ```
     r1 = 16; 
     r2 = 256; 
     r3 = 8; 
     r4 = 16; 
     r5 = 8; 
     r6 = 24; 
     r7 = 26; 
     r8 = 8; 
     r9 = 1; 
     data_mem[1] = 16; 
     others = 0 
     ```
    2. Testbench (“CO_P5_test_2.txt”): 
    ```asm
    addi $2, $0, 3 
    sw        $2, 0($0) 
    addi     $2, $0, 1 
    sw        $2, 4($0) 
    sw        $0, 8($0) 
    addi     $2, $0, 5 
    sw        $2, 12($0) 
    addi     $2, $0, 0  
    addi     $5, $0, 16 
    addi     $8, $0, 2 
    beq      $0, $0, 2 
    addi     $2, $2, 4 
    bge      $2, $5, 6 
    lw        $3, 0($2) 
    bgt       $3, $8, 1 
    beq      $0, $0, -5 
    addi     $3, $3, 1 
    sw        $2, 0($2) 
    beq      $0, $0, -8 
    ```
    Result: 
    ```
    r2 = 12; 
    r3 = 6; 
    r5 = 16; 
    r8 = 2; 
    data_mem[0] = 4 
    data_mem[1] = 1 
    data_mem[3] = 6 
    others = 0 
    ```

## Architecture Diagram
![image](https://github.com/XCI9/NYCU-2021-Spring-Computer-Organization/assets/71249961/6af4ca4d-9053-4e5d-9a04-d33c0ff2354d)


## Report
1. Your Architecture
2. Hardware Module Analysis
3. Problems You Met and Solutions
4. Result 
5. Summary

## Grade
1. Total: 120 points (plagiarism will get 0 point)
  - Report: 20 points (please use **pdf format**)
  - Hardware design: 80 points
  - Bonus: 20 points 
2. Late submission: Score * 0.8 before 6/27. After 6/27, you will get 0.
3. Wrong format: 10 points punishment

## Q&A
If you have any question, it is recommended to ask in the Facebook discussion forum.
