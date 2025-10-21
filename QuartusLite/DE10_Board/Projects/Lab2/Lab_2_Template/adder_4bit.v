
`default_nettype none

module adder_4bit(
	input 	[3:0] 	i_a,
	input 	[3:0] 	i_b,
	input 				i_cin,
	output 				o_cout,
	output 	[3:0] 	o_s
);

	// Combinational Logic only
	// TODO
	
	wire c1, c2, c3;
	FA fa0(i_a[0], i_b[0], i_cin, c1, o_s[0]);
	FA fa1(i_a[1], i_b[1], c1, c2, o_s[1]);
	FA fa2(i_a[2], i_b[2], c2, c3, o_s[2]);
	FA fa3(i_a[3], i_b[3], c3, o_cout, o_s[3]);
endmodule
