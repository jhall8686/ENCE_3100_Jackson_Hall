module main(
	input 	[9:0] 	SW,
	output 	[9:0] 	LEDR,
	output	[7:0]		HEX0,
	output	[7:0]		HEX1,
	output	[7:0]		HEX2,
	inout		[35:0]	GPIO
);
	wire [7:0] w_sum;
	
	adder_nbit #(.N(8)) ALU0(.A(SW[7:0]), .B(8'd6), .sub(SW[9]), .sum(w_sum), .cout(LEDR[8]));
	
	wire [3:0] w_ones, w_tens, w_hundreds;
	
	bin_to_bcd b2bcd(.bin(w_sum), .ones(w_ones), .tens(w_tens), .hundreds(w_hundreds));
	seg7Decoder seg0(.i_bin(w_ones), .o_HEX(HEX0));
	seg7Decoder seg1(.i_bin(w_tens), .o_HEX(HEX1));
	seg7Decoder seg2(.i_bin(w_hundreds), .o_HEX(HEX2));
endmodule