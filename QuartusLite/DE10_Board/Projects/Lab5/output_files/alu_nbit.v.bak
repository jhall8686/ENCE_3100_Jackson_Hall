module alu_nbit
#(
	parameter N = 8 //default
)
(
	input sub,
	input[N-1:0] A,
	input[N-1:0] B,
	output reg cout,
	output reg [N-1:0] sum
);
	always @(*) 
		{cout, sum} = (sub) ? A - B : A + B;
endmodule