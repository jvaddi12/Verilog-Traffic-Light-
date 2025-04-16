module clock_divider(
    input clk,
    input reset,
    output reg slow_tick
);
    // Adjust this parameter based on your clock frequency.
    // For example, for a 50 MHz clock and a desired tick rate of 10 Hz,
    // you might choose DIVISOR = 5_000_000.
    parameter DIVISOR = 5000000; 
    reg [31:0] count;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            slow_tick <= 0;
        end else begin
            if (count == DIVISOR - 1) begin
                count <= 0;
                slow_tick <= 1;
            end else begin
                count <= count + 1;
                slow_tick <= 0;
            end
        end
    end
endmodule
