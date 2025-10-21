
`default_nettype none

module multiplier_4x4(
	input 	[3:0] i_A,
	input 	[3:0] i_B,
	output 	[7:0] o_P,
	output 			o_Overflow
);

	wire [3:0] sum_s1, sum_s2, sum_s3;
	wire [3:0] c_s1, c_s2, c_s3;
	
	wire [3:0] b0_and, b1_and, b2_and, b3_and;
	
	//AND outputs
	assign b0_and = i_A & {4{i_B[0]}};
	assign b1_and = i_A & {4{i_B[1]}};
	assign b2_and = i_A & {4{i_B[2]}};
	assign b3_and = i_A & {4{i_B[3]}};
	
	
	// First Stage of Adders
	
	FullAdder fa00(.i_a(b0_and[1]), .i_b(b1_and[0]), .i_cin(1'b0), .o_cout(c_s1[0]), .o_sum(sum_s1[0]));
	FullAdder fa01(.i_a(b0_and[2]), .i_b(b1_and[1]), .i_cin(c_s1[0]), .o_cout(c_s1[1]), .o_sum(sum_s1[1]));
	FullAdder fa02(.i_a(b0_and[3]), .i_b(b1_and[2]), .i_cin(c_s1[1]), .o_cout(c_s1[2]), .o_sum(sum_s1[2]));
	FullAdder fa03(.i_a(1'b0), .i_b(b1_and[3]), .i_cin(c_s1[2]), .o_cout(c_s1[3]), .o_sum(sum_s1[3]));
	
	// Second Stage of Adders
	
	FullAdder fa10(.i_a(sum_s1[1]), .i_b(b2_and[0]), .i_cin(1'b0), .o_cout(c_s2[0]), .o_sum(sum_s2[0]));
	FullAdder fa11(.i_a(sum_s1[2]), .i_b(b2_and[1]), .i_cin(c_s2[0]), .o_cout(c_s2[1]), .o_sum(sum_s2[1]));
	FullAdder fa12(.i_a(sum_s1[3]), .i_b(b2_and[2]), .i_cin(c_s2[1]), .o_cout(c_s2[2]), .o_sum(sum_s2[2]));
	FullAdder fa13(.i_a(c_s1[3]), .i_b(b2_and[3]), .i_cin(c_s2[2]), .o_cout(c_s2[3]), .o_sum(sum_s2[3]));
	
	// Third Stage of Adders
	
	FullAdder fa20(.i_a(sum_s2[1]), .i_b(b3_and[0]), .i_cin(1'b0), .o_cout(c_s3[0]), .o_sum(sum_s3[0]));
	FullAdder fa21(.i_a(sum_s2[2]), .i_b(b3_and[1]), .i_cin(c_s3[0]), .o_cout(c_s3[1]), .o_sum(sum_s3[1]));
	FullAdder fa22(.i_a(sum_s2[3]), .i_b(b3_and[2]), .i_cin(c_s3[1]), .o_cout(c_s3[2]), .o_sum(sum_s3[2]));
	FullAdder fa23(.i_a(c_s2[3]), .i_b(b3_and[3]), .i_cin(c_s3[2]), .o_cout(c_s3[3]), .o_sum(sum_s3[3]));
	
	assign o_P = {c_s3[3], sum_s3[3:0], sum_s2[0], sum_s1[0], b0_and[0]};
	assign o_Overflow = c_s3[3];
endmodule
`default_nettype wire
