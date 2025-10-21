module mux_4_1(
	input 	s,
	input[3:0] x,
	input[3:0] y,
	output[3:0] m
);

	mux_2_1 m0(s,x[0],y[0],m[0]);
	mux_2_1 m1(s,x[1],y[1],m[1]);
	mux_2_1 m2(s,x[2],y[2],m[2]);
	mux_2_1 m3(s,x[3],m[3],m[3]);
endmodule
