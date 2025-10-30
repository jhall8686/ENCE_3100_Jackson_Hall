# Lab 8- Very Simple Microprocessor

![IMG_0367](https://github.com/user-attachments/assets/365642d7-801d-430c-b53b-7e106f4cb191)

All of the components required for a basic microprocessor have been covered now in this course, so this lab attempts to combine them all into a simple microprocessor that can read, interpret, and execute assembly instructions in the form of 8-bit binary numbers.

## Logisim Circuit

<img width="1292" height="1043" alt="image" src="https://github.com/user-attachments/assets/3acdfc7e-d064-4225-bd40-30f0e20515c9" />

This circuit outlines each important subsystem of the microprocessor; each individual circuit will be covered in the following sections.

## Accumulator A and B

The accumulators are simply registers that will be fed into the ALU. They differ slightly because of Accumulator A's capability to output its contents to the central bus. 

### Accumulator A

<img width="1103" height="849" alt="image" src="https://github.com/user-attachments/assets/aac27f71-278a-499f-9149-701780ccb635" />

Accumulator A is simply a 4-bit register with an enable pin that determines whether the output feeds into the central bus thanks to tri-state buffers. When translated to Verilog:

```verilog
`default_nettype none

module Accumulator_A #
(
	parameter N = 4
)
(
	input MainClock,
	input ClearA,
	input LatchA,
	input EnableA,
	input [N-1:0] A,
	output [N-1:0] IB_BUS,
	output reg [N-1:0] AluA
);
	
	
	// Sequential Logic
	
	always @(posedge MainClock) begin
		if(ClearA)
			AluA <= {N{1'b0}};
		else begin
			if(LatchA)
				AluA <= A;
		end
	end
	// Combinational Logic
	assign IB_BUS = EnableA ? AluA : {N{1'bz}};
/*
Importantly, 1'bz is not technically synthesizable (there are no floating pins within an FPGA),
but Quartus is smart enough to recognize the attempt at a tri-state buffer and does the multiplexer logic to replicate that.
*/
endmodule

`default_nettype wire
```

### Accumulator B

<img width="1211" height="791" alt="image" src="https://github.com/user-attachments/assets/5fc41a4c-e97c-46b6-a3c2-8c584f923b74" />

And because Accumulator B does not need the central bus output, it is just a 4-bit register:

```verilog
`default_nettype none

module Accumulator_B #
(
	parameter N = 4
)
(
	input MainClock,
	input ClearB,
	input LatchB,
	input [N-1:0] B,
	output reg [N-1:0] AluB
);

	// Sequential Logic
	
	always @(posedge MainClock) begin
		if(ClearB)
			AluB <= {N{1'b0}};
		else begin
			if(LatchB)
				AluB <= B;
		end
	end

endmodule

`default_nettype wire

```

## ALU

<img width="1244" height="1019" alt="image" src="https://github.com/user-attachments/assets/8ac687c5-d182-45eb-809e-88fdb007b4c7" />

While a 4-bit ALU is a hefty task with just behavioral logic (just look at the Logisim circuit above), `always` statements save the day, allowing for this verilog module to be relatively simple:

```verilog
`default_nettype none

module Arithmetic_Unit #
(
	parameter N = 4
)
(
	input EnableALU,
	input AddSub,
	input [N-1:0] A,
	input [N-1:0] B,
	output reg Carry,
	output reg [N-1:0] IB_ALU
);

reg [3:0] Sum;

always @(*) begin
	{Carry, Sum} = AddSub ? B - A : A + B;
	IB_ALU = EnableALU ? Sum : {N{1'bz}};
end
endmodule

`default_nettype wire
```

The same tri-state logic can be seen on the bus output, and the add/subtract functions are as simple as a `+` or a `-`. 

## In/Out Registers
### In
<img width="815" height="410" alt="image" src="https://github.com/user-attachments/assets/620bdac9-0c0b-4fd1-b3a9-0ab05404eaae" />

The input register doesn't actually need to be a register-- it only requires four tri-state buffers to prevent your input pins from always connecting to the bus. In Verilog:

```verilog
`default_nettype none

module InRegister #
(
	parameter N = 4
)
(
	input EnableIN,
	input [N-1:0] DataIn,
	output [N-1:0] IB_BUS
);

assign IB_BUS = EnableIN ? DataIn : {N{1'bz}};

endmodule

`default_nettype wire
```

Yet again, this only requires the tri-state logic from earlier.

### Out

<img width="1089" height="717" alt="image" src="https://github.com/user-attachments/assets/fc7a1f7a-de4c-4c9f-8466-9e07b5a5f17d" />

The output register does require a register to hold onto the data as the central bus gets disconnected to do other things. In Verilog:

```verilog
`default_nettype none

module OutRegister #
(
	parameter N = 4
)
(
	input MainClock,
	input MainReset,
	input EnableOut,
	input [N-1:0] IB_BUS,
	output reg [N-1:0] rOut
);

always @(posedge MainClock) begin
	if(MainReset)
		rOut <= {N{1'b0}};
	else if(EnableOut)
		rOut <= IB_BUS;
end
endmodule

`default_nettype wire
```

## Instruction Register

<img width="941" height="984" alt="image" src="https://github.com/user-attachments/assets/9c76be83-cfea-4a20-89d0-29df1a7674cf" />

The instruction register takes the 8-bit binary number from the current location in the program memory and splits it into two chunks-- the first four bits, which are the instruction and get passed to the control unit, and the last four, which function as the data for the assembly instruction. In Verilog, this is quite similar to the previous registers, but with two separate outputs:

```verilog
`default_nettype none

module InstructionReg #
(
	parameter N = 4
)
(
	input MainClock,
	input ClearInstr,
	input LatchInstr,
	input EnableInstr,
	input [N-1:0] Data,
	input [N-1:0] Instr,
	output reg [N-1:0] ToInstr,
	output [N-1:0] IB_BUS
);

	reg [3:0] w_Data;
	always @(posedge MainClock) begin
		if(ClearInstr)
			ToInstr <= {N{1'b0}};
		else if(LatchInstr) begin
			ToInstr <= Instr;
			w_Data <= Data;
		end
	end
	
	assign IB_BUS = EnableInstr ? w_Data : {N{1'bz}};
endmodule

`default_nettype wire
```

`ToInstr` and `w_Data` are the 4-bit buses that take each half of the 8-bit instruction. 

## Program Memory (Simulated ROM)

<img width="208" height="310" alt="image" src="https://github.com/user-attachments/assets/9e31b347-99a8-4ee5-9d2c-d1e8e08f2a6e" />

While ROM cannot be implemented with an FPGA, a RAM can be built that looks like it and instructions can be initialized onto it upon startup of the FPGA. In Verilog:

```verilog

`default_nettype none

module ROM_Nx8 #
(
	parameter N = 8
)
(
	input [$clog2(N)-1:0] address,
	output reg [7:0] data
);

	(* ramstyle = "logic" *) reg [7:0] rom [0:N-1];
	
	// Initialize memory -> asm instructions
	
	initial begin
		rom[0] = 8'h55;
		rom[1] = 8'h12;
		rom[2] = 8'h30;
		rom[3] = 8'h28;
		rom[4] = 8'h30;
		rom[5] = 8'h40;
		rom[6] = 8'h13;
		rom[7] = 8'h30;
		//Max 16 instructions
	end
	
	//Combinational Logic (async)
	always @(*) begin 
		data = rom[address];
	end
endmodule

`default_nettype wire
```

This creates an 8x8 memory block and stores 8 instructions on it, ready to be passed to the instruction register. 

## Program Counter

<img width="875" height="350" alt="image" src="https://github.com/user-attachments/assets/0ba4cc3f-1cd3-42dc-b86b-6ba231546420" />

The program counter iterates through the ROM by adding 1 to the address every 4 clock cycles (thanks to the EnableCount flag). In Verilog, there is no need for behavioral logic:

```verilog
`default_nettype none

module ProgramCounter #
(
	parameter N = 4
)
(
	input MainClock,
	input EnableCount,
	input ClearCounter,
	output reg [N-1:0] Counter
);

	always @(posedge MainClock) begin
		if(ClearCounter)
			Counter <= {N{1'b0}};
		else if(EnableCount)
			Counter <= Counter + 1;
	end
	
endmodule

`default_nettype wire
```

## Control Unit (FSM)

This control unit needs to execute the four phases of the uP cycle-- two fetch phases and two execute phases. This is why an instruction needs four clock cycles to complete. The following truth table details which flags need to be turned on for each phase in each instruction.

<img width="1294" height="453" alt="image" src="https://github.com/user-attachments/assets/177187cf-5a74-4ff1-9959-ff57a431808c" /> <!-- truth table-->

The state machine diagram is as follows (State A -> Phase 1, State B -> Phase 2, etc). The outputs of each state are determined by the above truth table.

![IMG_0369](https://github.com/user-attachments/assets/14394301-d01a-4b39-b3c7-f12c5fd42fc6)

To implement this in Verilog, the typical state machine structure is used, with the state register, next state logic, and output logic. 

### Initiation and Synchronous Logic
```verilog
`default_nettype none

module FSM_MicroInstr #
(
	parameter N = 4
)
(
	input clk,
	input reset,
	input [N-1:0] IB_BUS,
	
	output reg LatchA,
	output reg EnableA,
	output reg LatchB,
	output reg EnableALU,
	output reg AddSub,
	output reg EnableIN,
	output reg EnableOut,
	output reg LoadInstr,
	output reg EnableInstr,
	input [N-1:0]	ToInstr,
	output reg EnableCount
);

	reg [2:0] state, next_state;

	// States
	localparam [2:0] IDLE = 3'd0, PHASE_1 = 3'd1, PHASE_2 = 3'd2, PHASE_3 = 3'd3, PHASE_4 = 3'd4;

	// 1. State Register (sequential)
	always @(posedge clk) begin
		if(reset)
			state <= IDLE;
		else
			state <= next_state;
	end
	
	// 2. Next-State Logic (combinational)
	always @(*) begin
		
		next_state = state; // default: hold state
	
		case(state)
		
			IDLE: 
				begin		
					// Move to FETCH
					next_state = PHASE_1;
				end
			
			// FETCH Instruction
			PHASE_1:
				begin
					// Move to DECODE
					next_state = PHASE_2;
				end
			
			// DECODE Instruction	
			PHASE_2:
				begin
					// Move to EXECUTE A
					next_state = PHASE_3;
				end
				
			// EXECUTE A Instruction
			PHASE_3:
				begin
					// Move to EXECUTE B
					next_state = PHASE_4;
				end
			
			// EXECUTE B Instruction	
			PHASE_4:
				begin
					// Move to FETCH
					next_state = PHASE_1;
				end
				
			default: ;// None
		
		endcase
	end
	
	// 3. Output Logic (combinational)
	
	always @(*) begin
	
		// default all signals are zero
		LoadInstr 	= 1'b0;
		EnableInstr = 1'b0;
		LatchB 		= 1'b0;
		LatchA 		= 1'b0;
		EnableALU 	= 1'b0;
		EnableCount = 1'b0;
		AddSub		= 1'b0;
		EnableIN		= 1'b0;
		EnableA		= 1'b0;
		EnableOut	= 1'b0;
	
		case(state)
		
			IDLE: 
				begin
					// Initialize things if needed
				end
			
			// FETCH Instruction
			PHASE_1:
				begin
					LoadInstr = 1'b1;
				end
			
			// DECODE Instruction	
			PHASE_2:
				begin
					EnableCount = 1'b1;
					EnableInstr = 1'b1;
				end
				
			// EXECUTE Instruction
			PHASE_3:
				begin
					case(ToInstr)
						4'h00: //NOP
						begin
						end
						4'h01: //ADD
						begin
							LatchB 		= 1'b1;
							EnableInstr = 1'b1;
						end
						4'h02: //SUB
						begin
							LatchB 		= 1'b1;
							EnableInstr = 1'b1;
						end
						4'h03: //OUT
						begin
							EnableOut 	= 1'b1;
							EnableA 	 	= 1'b1;
						end
						4'h04: //IN
						begin
							EnableIN 	= 1'b1;
							LatchA 		= 1'b1;
						end
						4'h05: //LDA
						begin
							LatchA 		= 1'b1;
							EnableInstr = 1'b1;
						end
					endcase
				end
			
			// EXECUTE Instruction	
			PHASE_4:
				begin
					case(ToInstr)
						4'h00: //NOP
						begin
						end
						4'h01: //ADD
						begin
							LatchA 		= 1'b1;
							EnableALU 	= 1'b1;
						end
						4'h02: //SUB
						begin
							LatchA 		= 1'b1;
							EnableALU 	= 1'b1;
							AddSub 		= 1'b1;
						end
						4'h03: //OUT
						begin
						end
						4'h04: //IN
						begin
						end
						4'h05: //LDA
						begin
						end
					endcase					
				end
		
		endcase
	end

endmodule

`default_nettype wire
```

The next state logic is a reflection of the state machine diagram, and the output logic is a reflection of the truth table. 

## Putting It All Together

Once all of these submodules are constructed, they can be put together in the top module and the program stored in the ROM can be run. The Verilog code for the top module is as follows:

```verilog
`default_nettype none

module main(
	input		MAX10_CLK1_50,
	input		[1:0]		KEY,
	input		[9:0]		SW,
	inout		[35:0] 	GPIO,
	output	[9:0]		LEDR,
	output	[7:0]		HEX0,
	output	[7:0]		HEX1,
	output	[7:0]		HEX2,
	output	[7:0]		HEX4,
	output	[7:0]		HEX5
);

	localparam N = 4;

	// User Wires
	// ------------------------------
	wire w_clock = SW[9];
	wire w_reset = SW[8];
	
	wire [N-1:0] w_user_input = SW[3:0];
	
	wire w_carry;
	assign LEDR[9] = w_carry;
	
	wire [N-1:0] w_rOut;
	assign LEDR[3:0] = w_rOut;
	
	// DEBUG
	//assign LEDR[7:4] = w_AluA;
	
	// ------------------------------
	
	// Internal Wires
	// ------------------------------
	wire [N-1:0] w_IB_BUS;
	wire [N-1:0] w_AluA;
	wire [N-1:0] w_AluB;
	
	wire [N-1:0] w_counter;
	wire [N-1:0] w_data;
	wire [N-1:0] w_instruction;
	
	// ------------------------------
	
	// FSM CONTROL Wires
	// ------------------------------
	wire w_LatchA;
	wire w_EnableA;
	wire w_LatchB;
	wire w_EnableALU;
	wire w_AddSub;
	wire w_EnableIN;
	wire w_EnableOut;
	wire w_LoadInstr;
	wire w_EnableInstr;
	wire [N-1:0] w_ToInstr;
	wire w_ProgCount;
	wire w_EnableCount;
	// ------------------------------
	
	// Accumulator A (default 4bits)
	Accumulator_A AccA(
		.MainClock(w_clock),
		.ClearA(w_reset),
		.LatchA(w_LatchA),  		// FSM CONTROL
		.EnableA(w_EnableA),  	// FSM CONTROL
		.A(w_IB_BUS),
		.IB_BUS(w_IB_BUS),
		.AluA(w_AluA)
	);
	
	seg7Decoder SEG1(
		.i_bin(w_AluA),
		.o_HEX(HEX1)
	);
	
	// Accumulator B (default 4bits)
	Accumulator_B AccB (
		.MainClock(w_clock),
		.ClearB(w_reset),
		.LatchB(w_LatchB),  // FSM CONTROL
		.B(w_IB_BUS),
		.AluB(w_AluB)
	);
	
	seg7Decoder SEG2(
		.i_bin(w_AluB),
		.o_HEX(HEX2)
	);
	
	// ALU (default 4bits)
	Arithmetic_Unit ALU (
		.EnableALU(w_EnableALU),  	// FSM CONTROL
		.AddSub(w_AddSub),  			// FSM CONTROL
		.A(w_AluA),
		.B(w_AluB),
		.Carry(w_carry),
		.IB_ALU(w_IB_BUS)
	);
	
	seg7Decoder SEG0(
		.i_bin(w_IB_BUS),
		.o_HEX(HEX0)
	);
	
	// Input Register (default 4bits)
	InRegister InReg(
		.EnableIN(w_EnableIN),  // FSM CONTROL
		.DataIn(w_user_input),
		.IB_BUS(w_IB_BUS)
	);
	
	seg7Decoder SEG4(
		.i_bin(w_user_input),
		.o_HEX(HEX4)
	);
	
	// Output Register (default 4bits)
	OutRegister OutReg(
		.MainClock(w_clock),
		.MainReset(w_reset),
		.EnableOut(w_EnableOut),  // FSM CONTROL
		.IB_BUS(w_IB_BUS),
		.rOut(w_rOut)
	);
	
	seg7Decoder SEG5(
		.i_bin(w_rOut),
		.o_HEX(HEX5)
	);
	
	// Instruction Register (default 4bits)
	InstructionReg InstrReg(
		.MainClock(w_clock),
		.ClearInstr(w_reset),
		.LatchInstr(w_LoadInstr),  	// FSM CONTROL
		.EnableInstr(w_EnableInstr), 	// FSM CONTROL 
		.Data(w_data),
		.Instr(w_instruction),
		.ToInstr(w_ToInstr),
		.IB_BUS(w_IB_BUS)
	);
	
	// Program Counter (default 4bits)
	ProgramCounter ProgCounter (
		.MainClock(w_clock),
		.EnableCount(w_EnableCount),  // FSM CONTROL
		.ClearCounter(w_reset),
		.Counter(w_counter)
	);
	
	// Memory ROM 8x8
	
	wire [7:0] w_rom_data;
	
	ROM_Nx8 ROM (
		.address(w_counter[2:0]),
		.data(w_rom_data)
	);
	
	assign {w_instruction, w_data} = w_rom_data;
	
	// Microinstructions (FSM)
	FSM_MicroInstr Controller (
		.clk(w_clock),
		.reset(w_reset),
		.IB_BUS(w_IB_BUS),		
		.LatchA(w_LatchA),
		.EnableA(w_EnableA),
		.LatchB(w_LatchB),
		.EnableALU(w_EnableALU),
		.AddSub(w_AddSub),
		.EnableIN(w_EnableIN),
		.EnableOut(w_EnableOut),
		.LoadInstr(w_LoadInstr),
		.EnableInstr(w_EnableInstr),
		.ToInstr(w_ToInstr),
		.EnableCount(w_EnableCount)
	);

endmodule

`default_nettype wire
```

All this code is realistically doing is implementing the diagram at the top of this page. When it is synthesized and uploaded to the DE10, this is the result: 

<img src = "board-rec_uP.gif" />
