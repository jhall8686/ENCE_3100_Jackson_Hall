module main(
	input		MAX10_CLK1_50,
	input 	[9:0] 	SW,
	output 	[9:0] 	LEDR
);
	/*
	reg [24:0] counter;
	reg led;
	
	wire reset;
	assign reset = SW[0];
	
	always @(posedge MAX10_CLK1_50) begin
		if(reset)
			counter <= 0;
		else
			counter <= counter + 1;
			if(counter == 25'd25_000_000)
				led <= ~led;
				counter <= 0;
	end
	
	assign LEDR[0] = led;
	*/
	
	//with submodule
	
	wire clk_1s;
	
	counter_1s c0(.clk(MAX10_CLK1_50), .reset(SW[6]), .flag(clk_1s));
	
	shift_reg s0(.clk(clk_1s), .areset(SW[9]), .load(SW[8]), .ena(SW[7]), .data(SW[3:0]), .q(LEDR[3:0]));
	
	
endmodule