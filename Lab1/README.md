# Lab 1

## Part 1
#### Initialize switches and connect them to LEDs
The switches and LEDs are initialized in the top module, then connected with an `assign` statement.

<img src="img/code_sc1.png" width = 300/>

When pushed to the FPGA board (the Intel DE10-Lite), this results in the ten switches turning on their corresponding red LEDs.

## Part 2
#### Create an 8-bit 2-to-1 multiplexer
- *Importantly, the DE10 only has 10 switches, so an 8-bit multiplexer is not testable with the provided board. A 4-bit multiplexer was tested instead.*

To design an n-bit multiplexer, first a submodule must be designed that functions as a 1-bit 2-to-1 multiplexer:

<img src="img/code_sc2.png" width = 300/>

This submodule can then be used to create larger multiplexers:

