# Lab 3

***Disclaimer-- I am currently unable to upload gifs, so I am going to write the report without them and hopefully put them in later when I figure it out***

This lab will contain several sequential logic circuits implemented in Verilog.

### Part 1- SR Latch

The SR Latch is the first of the iconic sequential logic devices, and takes the following form:

<img width="531" height="315" alt="image" src="https://github.com/user-attachments/assets/410bdbd3-80b9-45b1-8e69-6721739093c7" />

Coding this in Verilog is quite simple, and can be done with a simple set of assigns:

<img width="482" height="356" alt="image" src="https://github.com/user-attachments/assets/e90e37c1-cd88-4c2a-8509-2cc866808452" />

The `/* synthesis keep */` portion of the code allows for the observation of internal signals R_g and S_g. Uploaded to Quartus, this is how the RTL Viewer looks:

<img width="1431" height="371" alt="image" src="https://github.com/user-attachments/assets/30e24deb-adb9-498c-bfe7-fa73a88ab154" />

The feedback and the storage lines R_g and S_g can clearly be seen.

When uploaded to the DE10, the board works based on its truth table:

| S (Set) | R (Reset) | Q  |
|---------|-----------|------------|
| 0       | 0         | Latch      |
| 0       | 1         | 0          |
| 1       | 0         | 1          |
| 1       | 1         | Invalid    |

The invalid case seems to simply output zero until the reset is sent through.

### Part 2- D Latch

The D latch takes the SR latch and updates it to only have one input (D) and only update the stored bit when the Clk is high. 

<img width="547" height="300" alt="image" src="https://github.com/user-attachments/assets/ae957f67-91ae-4802-97d9-40a5703281e4" />

In Verilog:

<img width="491" height="400" alt="image" src="https://github.com/user-attachments/assets/39278f55-2d08-45ef-b411-4b5c82270a01" />

- `/* synthesis keep */` remains in order to see the intermediate wires.

And viewed in the RTL Viewer after synthesizing:

<img width="1417" height="382" alt="image" src="https://github.com/user-attachments/assets/5ff0257f-c31e-4531-b8aa-92a0b037b609" />

The schematic, while different in layout from the drawn one, is functionally the same.

When uploaded to the DE10, the latch functions according to its truth table:

| D | Clk | Q |
|---|----|----------|
| 0 | 0  | Latch  |
| 1 | 0  | Latch  |
| 0 | 1  | 0        |
| 1 | 1  | 1        |

Now there are no illegal states.

### Part 3- Master-Slave D-Flip-Flop

Now, two D latches are put in seriers in order to get edge-triggering behavior, with this configuration also known as master-slave due to the first D latch governing the output of the second one.

<img width="751" height="259" alt="image" src="https://github.com/user-attachments/assets/1db49be2-1547-417c-9d06-ea05decb2762" />

In Verilog, the module can be built from two dlatchv1 modules:

<img width="336" height="198" alt="image" src="https://github.com/user-attachments/assets/cef2297a-81dd-4a11-a03b-0103d0922cdd" />

And after synthesizing and viewing in the RTL Viewer:

<img width="1096" height="564" alt="image" src="https://github.com/user-attachments/assets/4d4f4afd-18c2-4fbb-a3a5-c93db158958c" />

When uploaded to the DE10, the latch outputs its next value on a positive edge trigger, following its truth table:

| D | CLK | Q |
|---|-----|----------|
| 0 | ↑   | 0        |
| 1 | ↑   | 1        |
| – | 0   | Latch |
| – | 1   | Latch |

### Part 4- Three Types of DFFs

*Note- this section swaps from* `assign` *statements to* `always @()` *blocks for the clear ease in writing sequential logic.*

<img width="354" height="434" alt="image" src="https://github.com/user-attachments/assets/2601b3d6-3e47-4572-a408-9ce52d5dfabc" />

This part requires the design of D logic circuits-- the D latch, the positive edge-triggered D-flip-flop, and the negative edge-triggered D-flip-flop. All of these can be designed in always blocks:


