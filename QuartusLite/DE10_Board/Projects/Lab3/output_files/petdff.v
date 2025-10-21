module petdff(
	input Clk,
	input D,
	output reg Q
	);
	
	always @(posedge Clk) begin
		
		Q <= D;
		
	end
	
	
endmodule