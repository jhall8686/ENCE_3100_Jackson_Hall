module dlatch_v2(
	input Clk,
	input D, 
	output reg Q
	);
	
	always @(*) begin
		if(Clk)
			Q <= D;
	end
	
endmodule