module counter_3s
#(
	parameter CLK_SPEED = 50_000_000,
	parameter WIDTH = 26
)
(
	input clk,
	input rst,
	input en,
	output reg [1:0] count,
	output reg counter_done
	);
	
	reg [WIDTH-1:0] clk_count;
	
	
	always @(posedge clk) begin
		if(rst) begin
			clk_count <= {WIDTH{1'b0}};
		end
		else if(en) begin
			clk_count <= clk_count + 1;
			if(clk_count == CLK_SPEED - 1) begin
				clk_count <= {WIDTH{1'b0}};
				count <= count + 1;
			end
			if(count == 2'd3) begin
				counter_done <= 1'b1;
				count <= 2'd0;
				clk_count <= {WIDTH{1'b0}};
			end else
				counter_done <= 1'b0;

		end
		else
			counter_done <= 1'b0;
	end
endmodule