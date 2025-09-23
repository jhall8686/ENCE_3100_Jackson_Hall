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




