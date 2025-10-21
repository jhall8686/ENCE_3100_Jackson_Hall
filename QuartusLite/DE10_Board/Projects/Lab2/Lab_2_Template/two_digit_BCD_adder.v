module two_digit_BCD_adder(
	input[3:0] a0,
	input[3:0] a1,
	input[3:0] b0,
	input[3:0] b1,
	input cin,
	output[7:0] seg0,
	output[7:0] seg1,
	output[7:0] seg2
	);
	
	// m 7segment display (1's digit)
	wire[3:0] ms;
	wire mcout;
	wire[3:0] ma;
	wire mzout;
	
	adder_4bit add0(a0[3:0], b0[3:0], cin, mcout, ms[3:0]);
	bin_to_dec_v3 b2d0(ms[3], ms[2], ms[1], ms[0], mcout, ma[3], ma[2], ma[1], ma[0], mzout);
	bcd_to_7seg b2s0(ma[3], ma[2], ma[1], ma[0], seg0[7:0]);
	
	//n 7 segment display (10's digit)
	wire[3:0] ns;
	wire ncout;
	wire[3:0] na;
	wire nzout;
	adder_4bit add1(a1[3:0], b1[3:0], mzout, ncout, ns[3:0]);
	bin_to_dec_v3 b2d1(ns[3], ns[2], ns[1], ns[0], ncout, na[3], na[2], na[1], na[0], nzout);
	bcd_to_7seg b2s1(na[3], na[2], na[1], na[0], seg1[7:0]);
	
	//k 7 segment display (100's digit)
	circuit_B circB0(nzout, seg2[7:0]);
	
endmodule
	
	