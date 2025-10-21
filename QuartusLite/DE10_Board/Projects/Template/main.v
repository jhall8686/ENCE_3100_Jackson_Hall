module main(
	input 	[9:0] 	SW,
	output 	[9:0] 	LEDR,
	inout		[35:0]	GPIO
);

	assign LEDR = SW;


endmodule