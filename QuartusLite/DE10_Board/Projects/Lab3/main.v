module main(
	input 	[9:0] 	SW,
	input		[1:0]		KEY,
	output 	[9:0] 	LEDR,
	output	[6:0]		HEX0,
	output	[6:0]		HEX1,
	output	[6:0]		HEX2,
	output	[6:0]		HEX3
);
	// Part 1 checked

	/*
	
	rslatch rs0(SW[2], SW[1], SW[0], LEDR[0]);
	
	*/
	
	//Part 2 doesnt work
	
	/*
	
	dlatchv1 d0(SW[1], SW[0], LEDR[0]);
	
	*/
	
	//Part 3
	
	/*
	
	ms_dff dff0(SW[1], SW[0], LEDR[0]);

	*/
	
	//Part 4
	
	/*
	
	dlatch_v2 d0(SW[1], SW[0], LEDR[0]);
	pet_dff p0(SW[1], SW[0], LEDR[1]);
	net_dff n0(SW[1], SW[0], LEDR[2]);
	
	*/
	
	//Part 5
	
	wire [7:0] A, B;
	
	hex_reg8bit hr0(.areset(KEY[0]), .clk(KEY[1]), .data(SW[7:0]), .q(A));
	hex2dig_to7seg hts0(.hex(A),.seg1(HEX0),.seg2(HEX1));
	hex2dig_to7seg hts1(.hex(SW[7:0]), .seg1(HEX2), .seg2(HEX3));
	
endmodule