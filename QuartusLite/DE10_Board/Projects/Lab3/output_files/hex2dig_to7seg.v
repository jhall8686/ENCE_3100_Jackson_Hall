module hex2dig_to7seg(
	input [7:0] hex,
	output reg [6:0] seg1,
	output reg [6:0] seg2
	);
	
	always @(*) begin
        case (hex[3:0])
            4'h0: seg1 = 8'b11000000; // 0
            4'h1: seg1 = 8'b11111001; // 1
            4'h2: seg1 = 8'b10100100; // 2
            4'h3: seg1 = 8'b10110000; // 3
            4'h4: seg1 = 8'b10011001; // 4
            4'h5: seg1 = 8'b10010010; // 5
            4'h6: seg1 = 8'b10000010; // 6
            4'h7: seg1 = 8'b11111000; // 7
            4'h8: seg1 = 8'b10000000; // 8
            4'h9: seg1 = 8'b10010000; // 9
            4'hA: seg1 = 8'b10001000; // A
            4'hB: seg1 = 8'b10000011; // b
            4'hC: seg1 = 8'b11000110; // C
            4'hD: seg1 = 8'b10100001; // d
            4'hE: seg1 = 8'b10000110; // E
            4'hF: seg1 = 8'b10001110; // F
            default: seg1 = 8'b11111111; // all off (blank)
        endcase
        case (hex[7:4])
            4'h0: seg2 = 8'b11000000; // 0
            4'h1: seg2 = 8'b11111001; // 1
            4'h2: seg2 = 8'b10100100; // 2
            4'h3: seg2 = 8'b10110000; // 3
            4'h4: seg2 = 8'b10011001; // 4
            4'h5: seg2 = 8'b10010010; // 5
            4'h6: seg2 = 8'b10000010; // 6
            4'h7: seg2 = 8'b11111000; // 7
            4'h8: seg2 = 8'b10000000; // 8
            4'h9: seg2 = 8'b10010000; // 9
            4'hA: seg2 = 8'b10001000; // A
            4'hB: seg2 = 8'b10000011; // b
            4'hC: seg2 = 8'b11000110; // C
            4'hD: seg2 = 8'b10100001; // d
            4'hE: seg2 = 8'b10000110; // E
            4'hF: seg2 = 8'b10001110; // F
            default: seg2 = 8'b11111111; // all off (blank)
        endcase
	end
	

endmodule
	