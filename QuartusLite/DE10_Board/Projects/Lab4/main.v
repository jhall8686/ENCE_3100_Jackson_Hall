module main(
	input 				MAX10_CLK1_50,
	input 	[9:0] 	SW,
	input 	[1:0]		KEY,
	output 	[9:0] 	LEDR,
	output	[7:0]		HEX0,
	output	[7:0]		HEX1,
	output	[7:0]		HEX2,
	output	[7:0]		HEX3,
	output	[7:0]		HEX4,
	output	[7:0]		HEX5
);

	// Part I
	//******************

	// Create an 8-bit counter cascading 8 TFF
	// ---------------------------------------
	
	/*
	
	wire [7:0] wQ;
	wire [7:0] wEN;
	wire clk;
	wire clear;
	
	assign clk = KEY[0];
	assign clear = SW[1];
	assign wEN[0] = SW[0];
	
	
	tff0 t0(.ena(wEN[0]), .clk(clk), .clear(clear), .Q(wQ[0]));
	
	assign wEN[1] = wQ[0] & wEN[0];
	tff0 t1(.ena(wEN[1]), .clk(clk), .clear(clear), .Q(wQ[1]));
	
	assign wEN[2] = wQ[1] & wEN[1];
	tff0 t2(.ena(wEN[2]), .clk(clk), .clear(clear), .Q(wQ[2]));
	
	assign wEN[3] = wQ[2] & wEN[2];
	tff0 t3(.ena(wEN[3]), .clk(clk), .clear(clear), .Q(wQ[3]));
	
	assign wEN[4] = wQ[3] & wEN[3];
	tff0 t4(.ena(wEN[4]), .clk(clk), .clear(clear), .Q(wQ[4]));
	
	assign wEN[5] = wQ[4] & wEN[4];
	tff0 t5(.ena(wEN[5]), .clk(clk), .clear(clear), .Q(wQ[5]));
	
	assign wEN[6] = wQ[5] & wEN[5];
	tff0 t6(.ena(wEN[6]), .clk(clk), .clear(clear), .Q(wQ[6]));
	
	assign wEN[7] = wQ[6] & wEN[6];
	tff0 t7(.ena(wEN[7]), .clk(clk), .clear(clear), .Q(wQ[7]));

	

	// Connect 2 seg7Decoders to the output of the TFF counter
	// --------------------------------------------------------
	
		
	// seg7Decoder([3:0]i_bin, [7:0]o_HEX);
	seg7Decoder Ones(wQ[3:0], HEX0);
	seg7Decoder Tens(wQ[7:4], HEX1);
	
	//^28 logic elements
	
	*/
	
	//******************
	
	// Part II
	//******************

	// Connect 2 seg7Decoders to the output of the shift register
	// --------------------------------------------------------
	
	/*
	
	wire [15:0] wQ;
	
	counter_a(.ena(SW[0]), .clk(KEY[0]), .clear(SW[1]), .q(wQ));
	
	seg7Decoder dig1(wQ[3:0], HEX0);
	seg7Decoder dig2(wQ[7:4], HEX1);
	seg7Decoder dig3(wQ[11:8], HEX2);
	seg7Decoder dig4(wQ[15:12], HEX3);
	
	//46 logic elements

	*/
	
	//******************
	
	// Part III
	//******************	
	
	// Connect 2 seg7Decoders to the output of the LPM Counter
	// --------------------------------------------------------
	
	/*
	
	wire [15:0] wQ;
	
	my_lpm_counter(.clock(KEY[0]), .sclr(SW[1]), .cnt_en(SW[0]), .q(wQ));
	
	
	seg7Decoder dig1(wQ[3:0], HEX0);
	seg7Decoder dig2(wQ[7:4], HEX1);
	seg7Decoder dig3(wQ[11:8], HEX2);
	seg7Decoder dig4(wQ[15:12], HEX3);
	
	//Works the same but with active-high asynchronous clear and 46 logic elements
	
	*/
	
	//******************
	
	// Part IV
	//******************

	// Create 1 second counter
	// -----------------------
	
	/*
	
	wire [3:0] wCount;
	
	counter_1s(.clk(MAX10_CLK1_50), .count(wCount));

		
	// Connect the counter to one seg7Decoder
	// --------------------------------------
	
	seg7Decoder dig(wCount, HEX0);
	
	// Finally add additional logic to reset back to 0 when it reaches 9
	// -----------------------------------------------------------------
	
	//logic included in counter_1s
	
	*/
	
	//******************
	
	// Part V
	//******************
	//******************
	
	
	
	wire [2:0] wCount1, wCount2, wCount3, wCount4,wCount5, wCount6;
	
	counter_1s_3bit(.clk(MAX10_CLK1_50), .count1(wCount1), .count2(wCount2),
		.count3(wCount3),.count4(wCount4),.count5(wCount5),.count6(wCount6));
	
	hello_decoder(wCount1[2], wCount1[1], wCount1[0], HEX5);
	hello_decoder(wCount2[2], wCount2[1], wCount2[0], HEX4);
	hello_decoder(wCount3[2], wCount3[1], wCount3[0], HEX3);
	hello_decoder(wCount4[2], wCount4[1], wCount4[0], HEX2);
	hello_decoder(wCount5[2], wCount5[1], wCount5[0], HEX1);
	hello_decoder(wCount6[2], wCount6[1], wCount6[0], HEX0);
	
	
	
endmodule

`default_nettype none
