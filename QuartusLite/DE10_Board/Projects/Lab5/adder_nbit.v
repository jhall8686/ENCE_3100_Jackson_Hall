module adder_nbit #
(
	parameter N = 8 // default width
)
(
	input 	[N-1:0] 	i_a,
	input 	[N-1:0] 	i_b,
	input 				i_cin,
	output	[N-1:0]	o_sum,
	output 				o_cout
);

	assign {o_cout, o_sum} = i_a + i_b + i_cin;

endmodule
