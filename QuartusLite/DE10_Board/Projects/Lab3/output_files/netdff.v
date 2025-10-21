module netdff(
	input Clk,
	input D,
	output reg Q
	);
	
	always @(negedge Clk) begin
		
		Q <= D;
		
	end
	
	
endmodule