
`default_nettype none

module InstructionReg #
(
	parameter N = 4
)
(
	input MainClock,
	input ClearInstr,
	input LatchInstr,
	input EnableInstr,
	input [N-1:0] Data,
	input [N-1:0] Instr,
	output reg [N-1:0] ToInstr,
	output [N-1:0] IB_BUS
);

	reg [3:0] w_Data;
	always @(posedge MainClock) begin
		if(ClearInstr)
			ToInstr <= {N{1'b0}};
		else if(LatchInstr) begin
			ToInstr <= Instr;
			w_Data <= Data;
		end
	end
	
	assign IB_BUS = EnableInstr ? w_Data : {N{1'bz}};
endmodule

`default_nettype wire
