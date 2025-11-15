# Final Project - Wordle on an FPGA

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

The above sketch contains a messy version of this state diagram, but this is a more polished version of it. Each P state represents the location of the cursor, so in P2, only the first letter will have been typed. Beause of this, there needs to be an additional state on top of the five (`WORD`) that represents when all five letters have been typed in.

### Verilog Implementation

Obviously this control unit will have to take place inside a Verilog submodule. The following are the inputs and outputs, with notes on why each one is important:

```verilog
module Wordle_Control_FSM(
	input clk, //synchronous w/ rest of device
	input rst, //Reset state
	input [7:0] char_entered, //Grabs ASCII data from UART
	input char_sent, //1 if data has been sent over UART
	output reg [7:0] char1, //char1-5 store the letter outputs
	output reg [7:0] char2,
	output reg [7:0] char3,
	output reg [7:0] char4,
	output reg [7:0] char5,
	output reg [7:0] verdict_char, //outputs y or n for verdict (could encode more complex info, see Future Steps)
	output reg [2:0] state, //stores the current state (also output for debug purposes)
	output reg [2:0] next_state //stores the next state (output b/c attempted to use for debug, but turns out on a 50MHz clock state <= next_state pretty quick)
	);
```

With this I/O configuration, the meat of the state machine can be written, starting with the (first) synchronous portion of the code:

```verilog
reg char_flag;
	
	localparam P1 = 3'd0, P2 = 3'd1, P3 = 3'd2, P4 = 3'd3, P5 = 3'd4, VER = 3'd5, END = 3'd6, WORD = 3'd7;
	
	//sync logic
	
	always @(posedge clk) begin
		if(rst)
			state <= P1;
		else
			state <= next_state;
	end

```

`char_flag` will be important later; other than that, each `localparam` is a state, whcih will be interfaced in the next section of code. And the synchronous logic simply moves the state to the next one when the clock ticks. 

---

The next state logic is the largest and most important block of code here, essentially implementing all of the logic in the state diagram into code:

```verilog
//next state logic
	
	always @(*) begin
		
		case(state)
			P1: begin
				char_flag = char_sent;
				if(char_flag) begin
					char_flag = 1'b0;
					if(char_entered == 8'd127) begin //backspace pressed
						//stay here
						next_state = P1;
					end
					else begin
						//move to next 7 segment
						next_state = P2;
					end
				end 
				else
					next_state = P1;
			end
			P2: begin
				char_flag = char_sent;
				if(char_flag) begin
					char_flag = 1'b0;
					
					if(char_entered == 8'd127) begin //backspace pressed
            //back up
						next_state = P1;
					end
					else begin
						//move to next 7 segment
						next_state = P3;
					end
					
					next_state = P3;
				end 
				else
					next_state = P2;
			end
			P3: begin
				char_flag = char_sent;
				if(char_flag) begin
					char_flag = 1'b0;
					if(char_entered == 8'd127) begin //backspace pressed
            //back up
						next_state = P2;
					end
					else begin
						//move to next 7 segment
						next_state = P4;
					end
				end 
				else
					next_state = P3;
			end
			P4: begin
				char_flag = char_sent;
				if(char_flag) begin
					char_flag = 1'b0;
					if(char_entered == 8'd127) begin //backspace pressed
						//back up
						next_state = P3;
					end
					else begin
						//move to next 7 segment
						next_state = P5;
					end
				end 
				else
					next_state = P4;
			end
			P5: begin
				char_flag = char_sent;
				if(char_flag) begin
					char_flag = 1'b0;
					if(char_entered == 8'd127) begin //backspace pressed
						//back up
						next_state = P4;
					end
					else begin
						//move to next 7 segment
						next_state = WORD;
					end
				end 
				else
					next_state = P5;
			end
			WORD: begin
				char_flag = char_sent;
				if(char_flag) begin
					char_flag = 1'b0;
					if(char_entered == 8'd127) begin //backspace pressed
            //back up
						next_state = P5;
					end
					else if(char_entered == 8'd13) begin
						next_state = VER; //check for enter being pressed
					end else 
						next_state = WORD;
				end 
				else
					next_state = WORD;
			end
			VER: begin
				if(char1 == char2 && char2 == char3 && char3 == char4 && char5 == 8'd13) begin //**NOTE**: currently, enter (8'd13) gets put in the P5 slot before the verdict is checked, so that's a part of the correct verdict
					next_state = END; //correct verdict
				end else begin
					next_state = P1; //incorrect verdict
				end
			end
			END: begin
				
			end
		endcase
	end
```

Next, the output logic is needed-- this is also synchronous because the letters need to be stored in memory (avoids non-edge-triggered latches)

```verilog
	//Char Reg (output)
	
	always @(posedge clk) begin
		case(state)
			P1: begin
				/*
				if(char_entered == 8'd127)//backspace pressed
					char1 <= 8'd0;
				else
					char1 <= char_entered;
					*/
			end
			P2: begin
				if(char_entered == 8'd127)//backspace pressed
					char1 <= 8'd0;
				else
					char1 <= char_entered;
			end
			P3: begin
				if(char_entered == 8'd127)//backspace pressed
					char2 <= 8'd0;
				else
					char2 <= char_entered;
			end
			P4: begin
				if(char_entered == 8'd127)//backspace pressed
					char3 <= 8'd0;
				else
					char3 <= char_entered;
			end
			P5: begin
				if(char_entered == 8'd127)//backspace pressed
					char4 <= 8'd0;
				else
					char4 <= char_entered;
			end
			WORD: begin
				if(char_entered == 8'd127)//backspace pressed
					char5 <= 8'd0;
				else
					char5 <= char_entered;
			end
			VER: begin
				if(char1 == char2 && char2 == char3 && char3 == char4 && char4 == char5) begin
					char1 <= 8'd56;
					char2 <= 8'd56;
					char3 <= 8'd56;
					char4 <= 8'd56;
					char5 <= 8'd56;
					verdict_char <= 8'd121;
				end else begin
					char1 <= 8'd0;
					char2 <= 8'd0;
					char3 <= 8'd0;
					char4 <= 8'd0;
					char5 <= 8'd0;
					verdict_char <= 8'd110;
				end
			end
			END: begin
				
			end
		endcase
	end
```

## Putting it all Together

```verilog
`default_nettype none

module main(
	// Board I/Os
	input		MAX10_CLK1_50,
	input 	[9:0]		SW,
	output	[9:0]		LEDR,
	inout		[35:0]	GPIO,
	output 	[7:0]		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	//inout		[15:0]	ARDUINO_IO
);

	
	wire w_clk = MAX10_CLK1_50;

	
	wire RxD_data_ready;
	wire [7:0] RxD_data;
	reg [7:0] char_entered;

	async_receiver RX(
		.clk(w_clk), 
		.RxD(GPIO[35]), 
		.RxD_data_ready(RxD_data_ready), 
		.RxD_data(RxD_data)
	);
	
	always @(posedge w_clk) 
		if(RxD_data_ready) 
			char_entered <= RxD_data;

	async_transmitter TX(
		.clk(w_clk), 
		.TxD(GPIO[33]), 
		.TxD_start(RxD_data_ready), 
		.TxD_data(RxD_data)
	);
	
	//Control Unit and Outputs
	
	wire [2:0] w_place;
	wire [7:0] w_char1, w_char2, w_char3, w_char4, w_char5;
	wire [7:0] w_verdict_char;
	
	Wordle_Control_FSM fsm0(
		.clk(w_clk),
		.rst(SW[9]),
		.char_entered(char_entered),
		.char_sent(RxD_data_ready),
		.enter_flag(),
		.backspace_flag(),
		.place(w_place),
		.char1(w_char1),
		.char2(w_char2),
		.char3(w_char3),
		.char4(w_char4),
		.char5(w_char5),
		.verdict_char(w_verdict_char),
		.state(LEDR[2:0]),
		.next_state(LEDR[9:7]),
		.place(),
		.state_output()
	);
		
	
	
	char2seg Display1(
		.char(w_char1),
		.HEX0(HEX4)
	);
	
	char2seg Display2(
		.char(w_char2),
		.HEX0(HEX3)
	);
	char2seg Display3(
		.char(w_char3),
		.HEX0(HEX2)
	);
	char2seg Display4(
		.char(w_char4),
		.HEX0(HEX1)
	);
	char2seg Display5(
		.char(w_char5),
		.HEX0(HEX0)
	);
	
	char2seg VerdictDisplay(
		.char(w_verdict_char),
		.HEX0(HEX5)
	);
	
endmodule

`default_nettype wire
```

This results in the following reaction from the DE10 Board:

**GIF GOES HERE**
