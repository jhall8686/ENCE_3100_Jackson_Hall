module seven_seg_decoder(
	input[2:0] c,
	output[0:7] m
	);
	mux_2_1(c[2], ~(c[2] | c[0]), 1, m[0]);
	mux_2_1(c[2], (c[1] ^ c[0]), 1, m[1]);
	assign m[2] = m[1];
	mux_2_1(c[2], ~(c[1] | c[0]), 1, m[3]);
	assign m[4] = c[2];
	assign m[5] = c[2];
	mux_2_1(c[2], c[1], 1, m[6]);
	assign m[7] = 1;
	
endmodule
	