# Lab 6- Chess Timer

## State Machine

<img width="1236" height="819" alt="image" src="https://github.com/user-attachments/assets/c15d0178-c1d7-4265-97d1-602e3a36a155" />

The state machine is a Moore state machine with two 2-bit outputs, load and enable. Load resets the counters to their initial value (in the code it will be 5 seconds) and enable starts the counter (0 stops). There are additional given HEX outputs in the provided code that create the infrastructure for the chess clock (GO during the START state, timers during the P1/P2 states, and doneP1/doneP2 during the END state). The state machine implemented in the code is as follows:

<img width="819" height="418" alt="image" src="https://github.com/user-attachments/assets/cdf95497-40ed-414a-8599-2c88607e7d95" />

First the states must be defined (localparams). The states are encoded sequentially. Then comes the sequential logic of the system, which gives reset functionality and the transitioning between states on the rising edge of the clock.

<img width="660" height="571" alt="image" src="https://github.com/user-attachments/assets/c1fcdbc6-f74f-4f4c-a0ed-a16756cc9528" />

Now that the state will transition to next_state on every clock pulse, the logic for what next_state is needs to be implemented. This is the arrows of the state machine diagram, the transitions are determined by button presses and counters running out. 

Next, the outputs need to be defined:

<img width="500" height="436" alt="image" src="https://github.com/user-attachments/assets/628b528c-08fc-43b5-a233-bd76a7da4b1c" />

This reloads the counters on START, enables one to count down on its respective P state, and disables both counters on END. 

When this state machine is implemented into the surrounding infrastructure, the following behavior is observed:

<img src="img/board_rec_chess.gif"/>
