module dlatch(
	input clk,
	input d,
	output q
	);
	
	wire S_g, R_g, Qa, Qb /*synthesis keep*/;
	
	assign S_g = ~(d & clk);
	assign R_g = ~(~d & clk);
	assign Qa = ~(S_g & Qb);
	assign Qb = ~(R_g & Qa);
	
	assign q = Qa;
	
endmodule