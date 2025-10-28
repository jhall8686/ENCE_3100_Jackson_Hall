# Lab 7- UART Word Detector

In this lab, the DE10 Lite is used as a logic unit for a UART TX/RX loop which will display the character sent over UART until the word "HELLO" is detected, at which point the system will turn off for three seconds and display the word `HELLo` on the seven-segment displays, before reverting to the usual functionality.

<img width="736" height="738" alt="image" src="https://github.com/user-attachments/assets/c6203431-0e59-4e7a-859f-5a0db314a170" />

**System Block Diagram**

## Part 1- Predefined Circuitry

<img width="447" height="513" alt="image" src="https://github.com/user-attachments/assets/4722202f-a10a-4e67-bcf0-d49f5d034392" />

This is the portion of the code that was given-- the RX and TX are predefined and complicated, so I will not be going into them here. The important part is that they synchronously transmit and receive data through GPIO pins on the FPGA. The char2seg display simply converts from ASCII to the symbol received on the RX of the FPGA.

## Part 2- New Circuitry (FSM and Counter)

<img width="485" height="440" alt="image" src="https://github.com/user-attachments/assets/a3f17686-f42a-4ec8-86a3-19ca6d37e51d" />

### Hello Detection (FSM)

<img width="730" height="496" alt="image" src="https://github.com/user-attachments/assets/967f3515-48b0-4320-8292-602c031e992c" />

**Initial FSM Design**

A finite state machine is required for the detection of the word HELLO. The following is the declaration of inputs and outputs followed by the state storage variables, the state definitions, and the synchronous logic for the state machine, moving between states on each clock cycle. 

<img width="883" height="457" alt="image" src="https://github.com/user-attachments/assets/a0617952-e091-492c-9e14-51776c2649e9" />

The bulk of the important logic comes in the next state logic:

<img width="1025" height="213" alt="image" src="https://github.com/user-attachments/assets/9cdaff0e-ee19-44ab-b415-ea7624b20243" />

This does the same thing as the state machine diagram with combinational logic. 

And the last important bit is the output logic, which determines what is outputted by the state machine.

<img width="404" height="713" alt="image" src="https://github.com/user-attachments/assets/db98c9b5-a21f-4e6d-aaea-66b06b050537" />

During all states except O, the state machine simply displays the current ASCII character on `seg_data`. Once the O state is reached, this means that HELLO has been typed, so the `counter_start` signal is triggered. 

### Counter Logic

The `counter_3s` module takes the `counter_start` signal as an input to begin its count up to 3 at 1Hz. Once it completes this, it writes `counter_done` to 1, which will revert the state on the FSM and restart the system. 

<img width="537" height="662" alt="image" src="https://github.com/user-attachments/assets/c43af45b-fe05-4417-ae11-9d560422583a" />

## DE10 Implementation

This is what the code looks like after being uploaded to the DE10 and connected to a PC with Realterm running.

<img src="board_rec_hello.gif" width = "700"/>

