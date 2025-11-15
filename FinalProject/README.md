# Final Project- Wordle on an FPGA

When tasked with coming up with a project that would interest me for an FPGA, the game Wordle was one of the first things that came to mind.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/fe7d0c94-56e2-41ad-aaf9-0dc87eca97b7" />

The idea was intriguing to me because the 7-segment displays on the FPGA would be able to house the five letters, and it would fit right in with the finite state machines we have been learning. 

## Starting to Develop the Idea

### Block Diagram

The block diagram is the first thing to do in any project involving an FPGA, so I built mine:

<img width="1125" height="615" alt="image" src="https://github.com/user-attachments/assets/a807bffc-cde8-44ad-8eaa-5cd8014c3bd0" />

This was a preliminary diagram and a sketch, but nonetheless it exemplifies the different portions of the project that would need to be created:

- UART Comms (from a previous project)
- A Control Unit of some kind (FSM)
- Some form of memory to store the words
- A way to display the verdict
- A converter from ASCII to Seven-segment (also from a previous project)

The UART and char2seg modules are the easiest parts, as they're detailed in previous lab reports, so I won't be going over them here.

## Control Unit

The best option for the control unit on an FPGA, as always, is a finite state machine. 

### State Diagram

<img width="850" height="710" alt="image" src="https://github.com/user-attachments/assets/fee3c11f-18d1-4949-b9fc-36371c9b198a" />

The above sketch contains a messy version of this state diagram, but this is a more polished version of it. Each P state represents the location of the cursor, so in P2, only the first letter will have been typed. Beause of this, there needs to be an additional state on top of the five (`WORD`) 
