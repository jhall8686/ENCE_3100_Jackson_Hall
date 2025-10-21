module hello_decoder(
	input c2,
	input c1,
	input c0,
	output [7:0] m
	);
	assign m[0] = ~c2&~c0|c1|c2&c0;
	assign m[1] = c0|c1;
	assign m[2] = c0|c1;
	assign m[3] = ~c2&~c1&~c0|c2&c0|c2&c1;
	assign m[4] = c2&c0|c2&c1;
	assign m[5] = c2&c0|c2&c1;
	assign m[6] = c1|c2;
	assign m[7] = 1;
	
endmodule
