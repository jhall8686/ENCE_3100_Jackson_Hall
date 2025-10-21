
`default_nettype none

module FA(
	input 	i_a,
	input 	i_b,
	input 	i_cin,
	output 	o_cout,
	output 	o_s
);

	// Combinational Logic only
	// TODO
	wire w1;
	assign w1 = i_a ^ i_b;
	
	mux_2_1_1bit m0(i_b, i_cin, w1, o_cout);
	assign o_s = i_cin ^ w1;
	
endmodule
