
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

<<<<<<< HEAD
	reg [N-1:0] w_Data;
=======
	reg [3:0] w_Data;
>>>>>>> 0fc0b0d6320d78bf222e50deac36bce788930f7e
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
