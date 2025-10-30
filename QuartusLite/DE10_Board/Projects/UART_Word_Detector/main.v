
`default_nettype none

module main(
	// Board I/Os
	input		MAX10_CLK1_50,
	input 	[9:0]		SW,
	output	[9:0]		LEDR,
	inout		[35:0]	GPIO,
	output 	[7:0]		HEX0,
	output	[7:0] 	HEX1,
	output	[7:0] 	HEX2,
	output	[7:0] 	HEX3,
	output	[7:0] 	HEX4,
	output	[7:0]		HEX5
	//inout		[15:0]	ARDUINO_IO
);

	
	wire w_clk = MAX10_CLK1_50;

	
	wire RxD_data_ready;
	wire [7:0] RxD_data;
	reg [7:0] GPout;
	wire [7:0] seg_data;
	
	async_receiver RX(
		.clk(w_clk), 
		.RxD(GPIO[35]), 
		.RxD_data_ready(RxD_data_ready), 
		.RxD_data(RxD_data)
	);
	
	always @(posedge w_clk) 
		if(RxD_data_ready) 
			GPout <= RxD_data;

	async_transmitter TX(
		.clk(w_clk), 
		.TxD(GPIO[33]), 
		.TxD_start(RxD_data_ready), 
		.TxD_data(RxD_data)
	);
	

	char2seg Display(
		.char(GPout),
		.HEX0(seg_data)
	);
	
	wire w_counter_start, w_counter_done;
	FSM_Word_Detector fsm0(
		.clk(w_clk),
		.rst(SW[9]),
		.RxD_data(GPout),
		.Rx_detect(RxD_data_ready),
		.seg_data(seg_data),
		.counter_done(w_counter_done),
		.counter_start(w_counter_start),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5)
		);
	assign LEDR[5] = w_counter_start;
	assign LEDR[3] = w_counter_done;
	counter_3s count0(
		.clk(w_clk),
		.rst(SW[9]),
		.en(w_counter_start),
		.count(LEDR[1:0]),
		.counter_done(w_counter_done)
	);
endmodule

`default_nettype wire
