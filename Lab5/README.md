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

