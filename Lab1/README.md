<img width="268" height="127" alt="image" src="https://github.com/user-attachments/assets/ad2bd191-57df-4642-87f0-60ccc7c4a46f" /># Lab 1

## Part 1
#### Initialize switches and connect them to LEDs
The switches and LEDs are initialized in the top module, then connected with an `assign` statement.

<img src="img/code_sc1.png" width = 300/>

When pushed to the FPGA board (the Intel DE10-Lite), this results in the ten switches turning on their corresponding red LEDs.

## Part 2
#### Create an 8-bit 2 tp 1 multiplexer
- *Importantly, the DE10 only has 10 switches, so an 8-bit multiplexer is not testable with the provided board. A 4-bit multiplexer was tested instead.*

To design an n-bit multiplexer, first a submodule must be designed that functions as a 1-bit 2 to 1 multiplexer:

