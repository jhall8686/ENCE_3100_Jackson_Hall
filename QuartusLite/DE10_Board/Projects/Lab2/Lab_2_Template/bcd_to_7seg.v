module bcd_to_7seg(
	input c3,
	input c2,
	input c1,
	input c0,
	output[7:0] m
	);
	assign m[0] = ~c3&~c2&~c1&c0|c2&~c1&~c0;
	assign m[1] = c2&~c1&c0|c2&c1&~c0;
	assign m[2] = ~c2&c1&~c0;
	assign m[3] = ~c3&~c2&~c1&c0|c2&~c1&~c0|c2&c1&c0;
	assign m[4] = c0|c2&~c1;
	assign m[5] = ~c3&~c2&c0|~c2&c1|c1&c0;
	assign m[6] = ~c3&~c2&~c1|c2&c1&c0;
	assign m[7] = 1;
	
endmodule
	