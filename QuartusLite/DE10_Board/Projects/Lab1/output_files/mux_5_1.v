module mux_5_1(
	input s2,
	input s1,
	input s0,
	input u,
	input v,
	input w,
	input x,
	input y,
	output m
	);
	wire i1, i2, i3;
	mux_2_1 m0(s0,u,v,i1);
	mux_2_1 m1(s0,w,x,i2);
	mux_2_1 m2(s1,i1,i2,i3);
	mux_2_1 m3(s2,i3,y,m);

endmodule
	