module main(
	// Pinout Assignment
	input		[2:0] SW,
	output 	[0:7] HEX0,
	output 	[0:7] HEX1,
	output	[0:7] HEX2,
	output	[0:7] HEX3,
	output	[0:7] HEX4
);
	//assign LEDR = SW;
	wire[2:0] m0, m1, m2, m3, m4;
	
	mux_5_3 mux0(SW[2:0], 3'b000, 3'b001, 3'b010, 3'b010, 3'b011, m0);
	mux_5_3 mux1(SW[2:0], 3'b001, 3'b010, 3'b010, 3'b011, 3'b000, m1);
	mux_5_3 mux2(SW[2:0], 3'b010, 3'b010, 3'b011, 3'b000, 3'b001, m2);
	mux_5_3 mux3(SW[2:0], 3'b010, 3'b011, 3'b000, 3'b001, 3'b010, m3);
	mux_5_3 mux4(SW[2:0], 3'b011, 3'b000, 3'b001, 3'b010, 3'b010, m4);
	
	seven_seg_decoder s0(m0, HEX4[0:7]);
	seven_seg_decoder s1(m1, HEX3[0:7]);
	seven_seg_decoder s2(m2, HEX2[0:7]);
	seven_seg_decoder s3(m3, HEX1[0:7]);
	seven_seg_decoder s4(m4, HEX0[0:7]);
endmodule
