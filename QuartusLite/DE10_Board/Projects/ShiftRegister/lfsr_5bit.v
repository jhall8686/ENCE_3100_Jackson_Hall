module lfsr_5bit(
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    output reg [4:0] q
); 
    always @(posedge clk) begin
        if(reset)
            q <= 5'h1;
        else begin
            q[4] <= q[0] ^ 1'b0;
            q[3] <= q[4];
            q[2] <= q[3] ^ q[0];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end
endmodule