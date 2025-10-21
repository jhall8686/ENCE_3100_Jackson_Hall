module ram16x4_lut (
	input clk,
	input we,
	input [3:0] addr,
	input [3:0] din,
	output reg [3:0] dout
	);
	
	(* ramstyle = "logic" *) reg [3:0] mem [0:15];
	
	always @(posedge clk) begin
		if(we)
			mem[addr] <= din;
		dout <= mem[addr];
	end
endmodule