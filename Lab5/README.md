# Lab 5

The purpose of this lab was to walk through addition, subtraction, and multiplication using various techniques.

## Part 1 - Accumulator

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

## Part 3 - 4-Bit Multiplication with Full Adders

Multiplication by hand is done by adding shifted summands, and in digital logic, it is done much in the same way (the following multiplication and circuit are equivalent, and the shaded bars match up with similar operations).

<img height="400" alt="image" src="https://github.com/user-attachments/assets/3a68fbd6-2c30-43c9-9749-4854d35f697a" /> <img height="400" alt="image" src="https://github.com/user-attachments/assets/280cf0aa-6140-477b-8b6b-f9b31e913102" />

This circuit can be implemented in Verilog using a full adder module. While being careful in naming conventions for clarity in the code, the Verilog module looks as follows:

<img width="989" height="678" alt="image" src="https://github.com/user-attachments/assets/96115eef-6ab8-4659-9fb0-ee14c777215c" />

<img width="882" height="349" alt="image" src="https://github.com/user-attachments/assets/6be2a4f0-6635-4edf-b0fa-9c3ca92c4238" />

_(The full adder module)_

The AND operations are stored as wires in the format `bn_and`, which are then passed into the full adders. the carry bits are stored as wires in the format `c_sn`, and for each row, they link with each full adder (essentially creating a ripple adder, which the multiplier will be simplified with in [Part 4](#part-4---multiplication-with-ripple-carry-adders). For now, though, this adder can be implemented in the top module:

<img width="635" height="652" alt="image" src="https://github.com/user-attachments/assets/012164c1-5ab6-4748-9597-07688239495e" />

And synthesized on the DE10:

<img src="img/board_rec3.gif"/>

## Part 4 - Multiplication with Ripple Carry Adders

This part will forego the full adders in favor of an equivalent circuit, the ripple carry adder, the size of which can also be parametrized. It will also use memory elements to synchronize multiplication results with the clock:

<img width="604" height="386" alt="image" src="https://github.com/user-attachments/assets/27dfe4c5-7221-4c7e-9a29-f478dd1aab70" />

_**(The multiplier will be 8-bit rather than 5-bit and will have a 16-bit output)**_

<img width="552" height="314" alt="image" src="https://github.com/user-attachments/assets/bf5c33e0-4005-4035-aa25-e8801072595c" />

Implementing this for a multiplier is very similar to [Part 3](#part-3---4-bit-multiplication-with-full-adders):

<img width="984" height="829" alt="image" src="https://github.com/user-attachments/assets/4ad40a98-3e4f-4156-8be6-449de51728a1" />

Clearly the same sum and carry logic applies, but without the arrays of carry wires being needed. And since the adder can be parametrized, this one can be an 8-bit multiplier instead:

<img width="1131" height="889" alt="image" src="https://github.com/user-attachments/assets/3fd3817e-a943-4c34-9aed-60f831beaaa5" />

Now to implement in the top module (importantly, because of the lack of switches, the muliplication is happening with a fixed B of 100):

<img width="555" height="873" alt="image" src="https://github.com/user-attachments/assets/2d44bbb6-e636-4828-8de1-09f1f9ac5afb" />

And synthesized on the DE10:

<img src="img/board_rec4.gif"/>
