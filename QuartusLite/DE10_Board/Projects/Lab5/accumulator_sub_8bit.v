module accumulator_sub_8bit(
	input 	[7:0] i_A,
	input				i_addsub, // 1 - sub / 0 - add
	input 			i_clk,
	input				i_rst,
	output 			o_overflow,
	output 	[7:0] o_S
);
	wire [7:0] w_A, w_result;
	wire w_overflow;

	// 8bit Register
	reg_nbit #(.N(8)) (.i_clk(i_clk), .i_rst(i_rst), .i_R(i_A), .o_Q(w_A));
	// 8bit ALU
	assign {w_overflow, w_result} = (i_addsub) ? (o_S - w_A) : (o_S + w_A);
	// 1bit Register
	reg_nbit #(.N(1)) (.i_clk(i_clk), .i_rst(i_rst), .i_R(w_overflow), .o_Q(o_overflow));
	// 8bit Register
	reg_nbit #(.N(8)) (.i_clk(i_clk), .i_rst(i_rst), .i_R(w_result), .o_Q(o_S));
endmodule
