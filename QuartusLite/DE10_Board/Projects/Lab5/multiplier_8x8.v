
`default_nettype none

module multiplier_8x8(
	input 	[7:0] i_A,
	input 	[7:0] i_B,
	output 	[15:0] o_P,
	output 			o_Overflow
);
	
	wire [7:0] sum_s1, sum_s2, sum_s3, sum_s4, sum_s5, sum_s6, sum_s7;
	wire [6:0] w_cout;
	 
	wire [7:0] b0_and, b1_and, b2_and, b3_and, b4_and, b5_and, b6_and, b7_and;
	
	//AND outputs
	assign b0_and = i_A & {8{i_B[0]}};
	assign b1_and = i_A & {8{i_B[1]}};
	assign b2_and = i_A & {8{i_B[2]}};
	assign b3_and = i_A & {8{i_B[3]}};
	assign b4_and = i_A & {8{i_B[4]}};
	assign b5_and = i_A & {8{i_B[5]}};
	assign b6_and = i_A & {8{i_B[6]}};
	assign b7_and = i_A & {8{i_B[7]}};
	
	
	// First Stage of Adders
	
	adder_nbit #(.N(8)) add0 (.i_a({1'b0, b0_and[7:1]}), .i_b(b1_and[7:0]), .i_cin(1'b0), .o_cout(w_cout[0]), .o_sum(sum_s1));
	
	// Second Stage of Adders	
	
	adder_nbit #(.N(8)) add1 (.i_a({w_cout[0], sum_s1[7:1]}), .i_b(b2_and[7:0]), .i_cin(1'b0), .o_cout(w_cout[1]), .o_sum(sum_s2));
	
	// Third Stage of Adders
	
	adder_nbit #(.N(8)) add2 (.i_a({w_cout[1], sum_s2[7:1]}), .i_b(b3_and[7:0]), .i_cin(1'b0), .o_cout(w_cout[2]), .o_sum(sum_s3));
	
	// Fourth Stage of Adders
	
	adder_nbit #(.N(8)) add3 (.i_a({w_cout[2], sum_s3[7:1]}), .i_b(b4_and[7:0]), .i_cin(1'b0), .o_cout(w_cout[3]), .o_sum(sum_s4));
	
	// 5th Stage of Adders
	
	adder_nbit #(.N(8)) add4 (.i_a({w_cout[3], sum_s4[7:1]}), .i_b(b5_and[7:0]), .i_cin(1'b0), .o_cout(w_cout[4]), .o_sum(sum_s5));
	
	// 6th Stage of Adders
	
	adder_nbit #(.N(8)) add5 (.i_a({w_cout[4], sum_s5[7:1]}), .i_b(b6_and[7:0]), .i_cin(1'b0), .o_cout(w_cout[5]), .o_sum(sum_s6));
	
	// 7th Stage of Adders	
	
	adder_nbit #(.N(8)) add6 (.i_a({w_cout[5], sum_s6[7:1]}), .i_b(b7_and[7:0]), .i_cin(1'b0), .o_cout(w_cout[6]), .o_sum(sum_s7));
	
	
	//Result
	assign o_P = {w_cout[6], sum_s7, sum_s6[0], sum_s5[0], sum_s4[0], sum_s3[0], sum_s2[0], sum_s1[0], b0_and[0]};
	
	
	//Overflow
	assign o_Overflow = o_P[15];
	
endmodule

`default_nettype wire
