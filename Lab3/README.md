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

<img width="264" height="245" alt="image" src="https://github.com/user-attachments/assets/084783ec-a932-471f-a57d-3db315502e51" />
<img width="364" height="293" alt="image" src="https://github.com/user-attachments/assets/56f76075-e85e-40c3-a65a-ee71c95bd450" />
<img width="347" height="312" alt="image" src="https://github.com/user-attachments/assets/26707f7e-d962-4780-ad0f-bc5278c2ae7b" />

Clearly this is much simpler than the combinational logic with the assign statements, and is much preferrable. When this is synthesized and viewed in the RTL Viewer:

<img width="1354" height="931" alt="image" src="https://github.com/user-attachments/assets/8574b224-1503-4f92-91e9-f97e03ec713d" />

<img width="400" alt="image" src="https://github.com/user-attachments/assets/f1a1fb13-766c-4bf0-ad9f-e10594d6fd1f" />
<img width="400"  alt="image" src="https://github.com/user-attachments/assets/29034dc3-dc34-4705-a574-a9d7803c4b55" />
<img width="400" alt="image" src="https://github.com/user-attachments/assets/bb256360-126d-4c7d-a50a-d2c1d50cd31b" />

Because they sit in an always block and don't contain the `/* synthesis keep */` anymore, the system simply implements it with one lookup table and abstracts it as the actual latch/flip-flop.

When uploaded to the DE10, they each function according to each of their truth tables:

| D | Clk | D Latch Q | Pos-Edge DFF Q | Neg-Edge DFF Q |
|---|---------|-----------|----------------|----------------|
| – | 0       | latch     | latch          | latch          |
| 0 | 1       | 0         | latch          | latch          |
| 1 | 1       | 1         | latch          | latch          |
| 0 | ↑       | –         | 0              | latch          |
| 1 | ↑       | –         | 1              | latch          |
| 0 | ↓       | –         | latch          | 0              |
| 1 | ↓       | –         | latch          | 1              |

### Part 5- Storing Hex Numbers

THe capabilities of the DE10 prevent the 16-bit approach, but the same idea can be examined with 8-bit (2 digit hex) numbers.

This will simply require 8 bits of storage, which can be achieved in an always block, including the active-low asynchronous reset and positive-edge triggering clock.

Two submodules are created: one for the memory portion of the circuit, and one to convert an 8-bit binary input (2 digit hex) to 7 segment.

<img width="532" height="294" alt="image" src="https://github.com/user-attachments/assets/6412c31d-4dc7-4349-84f1-29846136f9ae" />

<img width="543" height="697" alt="image" src="https://github.com/user-attachments/assets/716893ac-da3c-4450-8e00-9fad19e960c0" />

To use them in the top module, the following is done:

<img width="725" height="128" alt="image" src="https://github.com/user-attachments/assets/56da9bbc-a4d6-49c8-9b53-abc03d535150" />

This automatically passes the 8 switch inputs to the HEX3 and HEX2, and when the clock triggers, it stores the data on the register and passes that info to HEX1 and HEX0. It works as expected when uploaded to the DE10.
