# Lab 4

### Part 1- T-Flip-Flop Counter

The T-Flip-Flop is the basic element for designing a counter. A 4-bit TFF counter is as follows:

<img width="780" height="241" alt="image" src="https://github.com/user-attachments/assets/e968680f-b092-4ba6-9966-c90df7fc07be" />

The clear bit is an active-low reset for the counter.

---
In order to build an 8-bit TFF counter in Verilog, a TFF is needed. When built with an edge-triggered DFF, it takes the following form:

<img width="318" height="175" alt="image" src="https://github.com/user-attachments/assets/751f0bd1-4f79-4fce-943e-8860b6a67e7b" />

Implementing this in Verilog:

<img width="401" height="266" alt="image" src="https://github.com/user-attachments/assets/bd9a23ff-bede-4521-868a-bde5c673bbcf" />

_Note: tff is already a primitive in Verilog, so tff0 was chosen as a substitute name for the module_

In order to build an 8-bit counter from these modules, I went straight to the top module, which could be considered a bad idea, but it works!

<img width="701" height="678" alt="image" src="https://github.com/user-attachments/assets/44e736d4-c5fe-48ed-b619-f7a45c4fb8a0" />

This essentially follows the above schematic (except doubled). The assign statements in between the tff0 modules handle the AND gates between the output of the module and its enable bit. It also translates the output into two 7 segment displays, so when uploaded to the DE10, it looks like this:

<img width = "400" src = "img/board_rec1.gif"/>

### Part 2- 16-Bit Counter with always

Counters can be abstracted in Verilog inside an `always` statement, specifically with the syntax `Q <= Q + 1`. This is far easier to code.

<img width="386" height="320" alt="image" src="https://github.com/user-attachments/assets/749b2753-201e-428c-afa0-fa448fe708ab" />

This does the same thing as if there were 16 of the TFF modules strung together, but in much less work. When implemented in the top module and translated into 7 segment:

<img width="608" height="186" alt="image" src="https://github.com/user-attachments/assets/f79285b7-d97e-461b-8e4f-28f9917feeb8" />

Now this functions similarly to the previous one, but with 4 hexadecimal digits as an output:

<img width = "400" src = "img/board_rec2.gif"/>

### Part 3- 16-Bit LPM Counter (Built-in)

Another method of developing a counter in Verilog is using Quartus's built-in library to generate one similar to our needs. After navigating to the LPM_COUNTER in the IP library, the following window opens:

<img width="794" height="374" alt="image" src="https://github.com/user-attachments/assets/3826ebef-5c74-4098-a75b-3722edc55c7d" /> <img width="686" height="390" alt="image" src="https://github.com/user-attachments/assets/55126358-6b55-48d2-9561-603a1f3f648b" />

Here, we can choose the input size and ensure that there is a clear input to match our previous counter. This can then be used in the same way as in Part 2:

<img width="800" height="224" alt="image" src="https://github.com/user-attachments/assets/37916517-adb0-4667-a943-30ecc5229621" />

And it functions the exact same, except for the clear bit being active high:

<img width = "400" src = "img/board_rec3.gif"/>

_(SW1 is low while the counter is functioning, indicating an active-high clear pin)_

### Part 4- 1-Second Decimal Counter

In this part, the goal is to have the seven segment display incrementing every 1 second and rolling over at 9. To do this, first a 1 second counter is needed. This can be done by building a 50MHz counter that increments a separate variable when the counter reaches 50,000,000 and resets it back to 0:

<img width="505" height="287" alt="image" src="https://github.com/user-attachments/assets/f1e50fad-52e0-4db6-97dc-b2ca80209ba0" />

To simplify the code, the logic to reset the 1 second counter to 0 after 9 is included within the module as well. 

Connecting to the top module and decoding the 4-bit number into 7 segment:

<img width="667" height="340" alt="image" src="https://github.com/user-attachments/assets/3fcc7c45-6448-46a9-a37e-74b294ce4aea" />

And when uploaded to the DE10, it increments every 1 second.

<img width = "400" src = "img/board_rec4.gif"/>

### Part 5- Rotating HELLO

This part will combine code from the previous parts and from Lab 1 in order to display HELLO rotating around the 7-segment displays:

<img width="530" height="301" alt="image" src="https://github.com/user-attachments/assets/6dfed6cb-9eb2-465f-8823-12006feca351" />

However, there are only six 7-segment displays on the DE10 board, so it will not function exactly like the above image.

This will be achieved in two parts: the first is a modified counter module, which will have 6 count outputs, each an increment of 1 apart from each other. These will pass into the next part, which will be a decoder that converts the 3-bit count output into a letter (or blank):

| c2 | c1 | c0 | Output |
|----|----|----|--------|
| 0  | 0  | 0  | H      |
| 0  | 0  | 1  | E      |
| 0  | 1  | 0  | L      |
| 0  | 1  | 1  | L      |
| 1  | 0  | 0  | O      |
| 1  | 0  | 1  | -      |
| 1  | 1  | 0  | -      |
| 1  | 1  | 1  | -      |

The truth table that decodes these into 7-segment outputs was built in Logisim, then used the Logisim-generated logic in a Verilog module:

<img width="430" height="250" alt="image" src="https://github.com/user-attachments/assets/0feb59b8-142e-4a70-80c6-47f9c07d7cb0" />

<img width="600" alt="image" src="https://github.com/user-attachments/assets/a65def23-c865-4d49-8e37-e36c557c26fa" /> <img width="400" alt="image" src="https://github.com/user-attachments/assets/18369e15-68be-4e48-bf45-a18dc7957eb2" />

Implementing this into the top module:

<img width="722" height="319" alt="image" src="https://github.com/user-attachments/assets/7f65a9af-0336-42bf-b84e-dc102a0ab9dd" />

When this code is uploaded to the DE10, the six 7-segment displays rotate through each bit and attain an overall look of the word 'HELLO' shifting.

<img width = "400" src = "img/board_rec5.gif"/>

