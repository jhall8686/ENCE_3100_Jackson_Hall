
`default_nettype none

module Arithmetic_Unit #
(
	parameter N = 4
)
(
	input EnableALU,
	input AddSub,
	input [N-1:0] A,
	input [N-1:0] B,
	output reg Carry,
	output reg [N-1:0] IB_ALU
);

reg [3:0] Sum;

always @(*) begin
	{Carry, Sum} = AddSub ? B - A : A + B;
	IB_ALU = EnableALU ? Sum : {N{1'bz}};
end
endmodule

`default_nettype wire
