module mux_5_3(
	input[2:0] s,
	input[2:0] u,
	input[2:0] v,
	input[2:0] w,
	input[2:0] x,
	input[2:0] y,
	output[2:0] m
	);
	mux_5_1 m0(s[2], s[1], s[0], u[2], v[2], w[2], x[2], y[2], m[2]);
	mux_5_1 m1(s[2], s[1], s[0], u[1], v[1], w[1], x[1], y[1], m[1]);
	mux_5_1 m2(s[2], s[1], s[0], u[0], v[0], w[0], x[0], y[0], m[0]);
endmodule