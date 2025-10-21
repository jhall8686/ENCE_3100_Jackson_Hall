module comparator_9(
	input [3:0] d,
	output reg q
	);
	
	always @(*) begin
		if(d >= 4'd9)
			q = 1;
		else
			q = 0;
	end
	
endmodule