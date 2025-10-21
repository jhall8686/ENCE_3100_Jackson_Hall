
`default_nettype none

module circuit_A_v2(
	input		i_cout,
	input 	i_v3,
	input 	i_v2,
	input 	i_v1,
	input 	i_v0,
	output 	o_a0,
	output 	o_a1,
	output 	o_a2,
	output 	o_a3
);

	// Combinational Logic only
	// TODO
	assign o_a3 = ~i_v3&i_v1|i_cout&i_v2&i_v1|i_cout&i_v1&i_v0;
	assign o_a2 = i_v2&i_v1|~i_v2&~i_v1;
	assign o_a1 = ~i_v1;
	assign o_a0 = i_v0;
endmodule

