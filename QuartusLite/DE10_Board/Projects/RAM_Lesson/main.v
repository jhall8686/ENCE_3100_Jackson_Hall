module main(
	input 	[9:0] 	SW,
	input		[1:0]		KEY,
	output 	[9:0] 	LEDR,
	inout		[35:0]	GPIO
);
	//ram32x8_lut(.clk(KEY[0]), .we(SW[8]), .addr({4'd0, SW[9]}), .din(SW[7:0]), .dout(LEDR[7:0]));

	//ram32x8_m9k(.clk(KEY[0]), .we(SW[8]), .addr({4'd0, SW[9]}), .din(SW[7:0]), .dout(LEDR[7:0]));
	
	ram32x8_ip	ram32x8_ip_inst (
	.address ({4'd0, SW[9]}),
	.clock (KEY[0]),
	.data (SW[7:0]),
	.wren (SW[8]),
	.q (LEDR[7:0])
	);

endmodule