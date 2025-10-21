module bin_to_bcd (
    input  [7:0] bin,         // 8-bit binary input
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    integer i;
    reg [19:0] shift_reg;     // 8 bits + 3*4 bits = 20 bits total

    always @(*) begin
        // Initialize shift register
        shift_reg = 20'd0;
        shift_reg[7:0] = bin;

        // Perform 8 iterations (one for each input bit)
        for (i = 0; i < 8; i = i + 1) begin
            // Add 3 if BCD digit >= 5
            if (shift_reg[11:8] >= 5)
                shift_reg[11:8] = shift_reg[11:8] + 3;   // ones
            if (shift_reg[15:12] >= 5)
                shift_reg[15:12] = shift_reg[15:12] + 3; // tens
            if (shift_reg[19:16] >= 5)
                shift_reg[19:16] = shift_reg[19:16] + 3; // hundreds

            // Shift left by 1 bit
            shift_reg = shift_reg << 1;
        end

        // Extract the BCD digits
        hundreds = shift_reg[19:16];
        tens     = shift_reg[15:12];
        ones     = shift_reg[11:8];
    end
endmodule