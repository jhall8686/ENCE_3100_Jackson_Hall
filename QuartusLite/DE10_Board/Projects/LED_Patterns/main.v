module main(
	// Board I/Os
	input		MAX10_CLK1_50,
	input 	[9:0]		SW,
	input [1:0] KEY,
	output	reg [9:0]		LEDR,
	output	[35:0]	GPIO
);

	wire w_clk = MAX10_CLK1_50;

	wire [4:0] w_rst, w_en, w_dir;
	wire [2:0] w_sel_bits;
	wire [9:0] w_LEDR_1, w_LEDR_2, w_LEDR_3, w_LEDR_4, w_LEDR_5;

	FSM_Patterns(.clk(SW[0]), .rst(SW[5]), .w(SW[1]), .q(w_sel_bits));
	
	
	assign w_rst = {5{SW[9]}};
	assign w_en = {5{SW[8]}};
	assign w_dir = {5{SW[3]}};
	
	Pattern1 Patt1(.clk(w_clk), .rst(w_rst[0]), .en(w_en[0]), .dir(w_dir[0]), .counter(w_LEDR_1));
	Pattern2 Patt2(.clk(w_clk), .rst(w_rst[1]), .en(w_en[1]), .dir(w_dir[1]), .counter(w_LEDR_2));
	Pattern3 Patt3(.clk(w_clk), .rst(w_rst[2]), .en(w_en[2]), .dir(w_dir[2]), .counter(w_LEDR_3));
	Pattern4 Patt4(.clk(w_clk), .rst(w_rst[3]), .en(w_en[3]), .dir(w_dir[3]), .counter(w_LEDR_4));
	Pattern5 Patt5(.clk(w_clk), .rst(w_rst[4]), .en(w_en[4]), .dir(w_dir[4]), .counter(w_LEDR_5));
	
	//FSM_Patterns fsmp(.clk(SW[0]), .w(SW[1]), .rst(SW[9]), .q(w_sel_bits));
	
	always @(*) begin
		
		LEDR = 10'd0;
	
		case(w_sel_bits)
			3'd0: LEDR = w_LEDR_1;
			3'd1: LEDR = w_LEDR_2;
			3'd2: LEDR = w_LEDR_3;
			3'd3: LEDR = w_LEDR_4;
			3'd4: LEDR = w_LEDR_5;
			default: LEDR = 10'd0;
		endcase
	end
/*
	
	always @(*) begin
		case(w_state)
			3'd0: out = out1;
			3'd1: out = out2;
			3'd2: out = out3;
			3'd3: out = out4;
			3'd4: out = out5;
			default: out = 0;
		endcase
	end
	
*/	
endmodule
