module mux_8_1(
	input 	s,
	input[7:0] 	X,
	input[7:0] 	Y,
	output[7:0]	M
);

	mux_2_1 m0(s,X[0],Y[0],M[0]);
	mux_2_1 m1(s,X[1],Y[1],M[1]);
	mux_2_1 m2(s,X[2],Y[2],M[2]);
	mux_2_1 m3(s,X[3],Y[3],M[3]);
	mux_2_1 m4(s,X[4],Y[4],M[4]);
	mux_2_1 m5(s,X[5],Y[5],M[5]);
	mux_2_1 m6(s,X[6],Y[6],M[6]);
	mux_2_1 m7(s,X[7],Y[7],M[7]);
endmodule