# Lab 5

The purpose of this lab was to walk through addition, subtraction, and multiplication using various techniques.

### Part 1 - Accumulator

The accumulator circuit, as seen below, adds the inputted number to the final total, thus "accumulating" the total. 

<img width="576" height="434" alt="image" src="https://github.com/user-attachments/assets/c5e07c9b-4ef7-4f75-aba2-2eec45ed2562" />

To implement this in Verilog, four modules need to be instantiated— three of them can be instantiated with an n-bit register module, pictured below:

<img width="452" height="375" alt="image" src="https://github.com/user-attachments/assets/0c0e3716-b596-4bb4-8a58-ba71361cd696" />

The last module is a simple ALU, which can be designed in one line. Therefore, the full accumulator module looks like this:

<img width="925" height="405" alt="image" src="https://github.com/user-attachments/assets/dbdf82b7-4e63-4776-b2b5-4f6300bab464" />

Implementing the accumulator in the top module:

<img width="401" height="588" alt="image" src="https://github.com/user-attachments/assets/34d0ad9e-0fee-4056-b56b-e8b231a65fae" />

This takes the output and converts it into a 2-digit BCD number to be displayed with the 7-segment displays. When uploaded to the DE10, it behaves as expected:

<img src="img/board_rec1.gif"/>

### Part 2 - Accumulator/Subtractor

This circuit is largely the same as in Part 1, but includes an input subtract bit, which determines whether input A get subtracted from the final sum or added to it. the accumulator circuit changes as follows:

<img width="952" height="415" alt="image" src="https://github.com/user-attachments/assets/dd173bf7-b3d2-4deb-b691-4fc48b3cb0b2" />

The only line that changes is the ALU line, which has been swapped for a ternary statement that instead performs subtraction if the subtract bit is 1. Implementing this in the top module:

<img width="595" height="507" alt="image" src="https://github.com/user-attachments/assets/a0049611-d495-44fd-8b10-6472d2fa98cf" />

And synthesizing on the DE10:

<img src="img/board_rec2.gif"/>

### Part 3 - Multiplication with Full Adders

Multiplication by hand is done by adding shifted summands, and in digital logic, it is done much in the same way.

<img height="600" alt="image" src="https://github.com/user-attachments/assets/3a68fbd6-2c30-43c9-9749-4854d35f697a" /> <img height="600" alt="image" src="https://github.com/user-attachments/assets/280cf0aa-6140-477b-8b6b-f9b31e913102" />


