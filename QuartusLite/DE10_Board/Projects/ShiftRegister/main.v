module main(
	input		MAX10_CLK1_50,
	input 	[9:0] 	SW,
	input		[1:0]		KEY,
	output 	[9:0] 	LEDR
);
	//module shift_register_4bit(input clk,input areset,input load,input ena,input[3:0] data,output reg[3:0] q); 

	//shift_register_4bit SR0(SW[0], SW[9], SW[1], SW[2], SW[6:3], LEDR[3:0]);

	lfsr_5bit LF0(SW[0], SW[9], LEDR[4:0]);
endmodule