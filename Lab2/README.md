# Lab 2


## Part 1

#### Binary BCD to Seven-Segment Display Decoder

While the DE-10 Board cannot have four separate BCD inputs, they can all receive the same four bits. The logic can be determined from the truth table for the seven segment display, which can be assembled manually from the datasheet showing which bit turns on which segment:

<img src="img/misc_sc1.png" height = 300/> <img src="img/table_sc1.png" height = 300/>

This truth table results in the following circuit (generated from the truth table in Logisim):
<img src="img/sch_sc1.png" height = 600/>

The window on the right contains the expressions required for the Verilog code, so the BCD to Seven-Segment Display Decoder Module is simply seven assign statements with those logical statements:

<img src="img/code_sc1.png" height = 300/>

Implementing in the top module:

<img src="img/code_sc2.png" height = 200/>

The DE10 after uploading the code:

<img src="img/board_rec1.gif" height = 200/>

## Part 2

#### Binary to Decimal Converter

This circuit is intended to take a 4-bit number and display it correctly in decimal on two seven-segment displays.

<img src="img/table_sc2.png" height = 300/>

Most of the circuit is given, with three subcircuits needing to be defined:

<img src="img/sch_sc2.png" height = 600/> 

##### Comparator

The comparator simply needs to determine if the 4-bit input number is greater than nine. The truth table for this is simple to construct:

<img src="img/table_sc3.png" width = 300/>

Which results in this circuit:

<img src="img/sch_sc3.png" height = 600/> 

As a Verilog module:

<img src="img/code_sc4.png" height = 300/>

##### Circuit A

Circuit A needs to translate the second digit of the decimal number if the number is greater than nine (the select bit from the comparator is turning on all of the multiplexers). Naturally, this can be accomplished by mapping the last three binary digits to the correct three bit second digit. This happens to be subtracting (10)<sub>2</sub> from the number:

<img src="img/table_sc3.png" height = 300/> <img src="img/sch_sc4.png" height = 300/> 

As a Verilog module:

<img src="img/code_sc3.png" height = 300/>

##### Circuit B

Circuit B simply needs to translate z (the output of the comparator) into its seven-segment display equivalent, which can (similarly to Part 1) be assembled manually from the chart in the data sheet:

<img src="img/sch_sc5.png" height = 300/> 

As a Verilog module:

<img src="img/code_sc5.png" height = 300/>

##### Integration

Putting all of these modules together with the muxes from Lab 1 and the module from Part 1, the top module is as follows:

<img src="img/code_sc6.png" height = 400/>

The DE10 after uploading the code:

<img src="img/board_rec2.gif" height = 200/>

## Part 3

#### Four Bit Addder

This part requires a ripple-carry adder built out of four full adders, a submodule that itself must be designed in Verilog.

<img src="img/misc_sc2.png" height = 300/>

The FA submodule from the above truth table:

<img src="img/code_sc7.png" height = 300/> 

And now connecting four of these submodules with rippling carry bits:

<img src="img/code_sc8.png" height = 300/> 

Connecting to the top module is as simple as connecting the `adder_4bit` module to have two 4-bit switch inputs and five LED outputs, and when sent to the DE10:

<img src="img/board_rec3.gif" height = 200/>

## Part 4

#### Adding Two BCD Numbers

This part is just the 4-bit adder from Part 3 fed into a circuit that is very similar to Part 2 (with some modifications). For one, numbers up to 19 (9 + 9 + 1) can now be outputted, so the second digit needs to be capable of displaying as all 10 digits. Additionally, the c<sub>out</sub> bit means that some changes are required to each circuit. Lastly, a checkBCD module was implemented in order to check if the numbers inputted into the adder are both valid BCD digits.

The new full circuit design looks like the following:

<img src="img/sch_sc6.png" height = 600/>

*The BCD to 7-Segment portion of the circuit was omitted in favor of Logisim's hex displays, which have the converter built in and simply take 4-bit numbers*

The two notable changes from the circuit in Part 2 are the additional input to Circuit A, which will be detailed below, and the comparator output z being OR'ed with c<sub>out</sub>. This is because the carry out being activated automatically means that the number is above 9, but would not cause that output from the comparator.

##### Circuit A v2

Circuit A must now convert the second digit of 10-19 instead of 10-15, which requires a more robust circuit with two more inputs and one more output. The same process as in Part 2 was done with the truth table (matching relevant inputs to the resulting output), which resulted in the following circuit:

<img src="img/sch_sc7.png" height = 600/>

In Verilog:







