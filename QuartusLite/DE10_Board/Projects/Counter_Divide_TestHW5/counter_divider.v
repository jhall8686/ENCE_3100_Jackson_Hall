module counter_divider(
	input clk,
	output clk2,
	output clk4
	);
	wire w_q1, w_q2;
	
	dflipflop dff0(.clk(clk), .d(~w_q1), .q(w_q1));
	dflipflop dff1(.clk(w_q1), .d(~w_q2), .q(w_q2));
	
	assign clk2 = w_q1;
	assign clk4 = w_q2;
	
endmodule