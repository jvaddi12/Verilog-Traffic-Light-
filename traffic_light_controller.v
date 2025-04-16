module traffic_light_controller(
    input clk,
    input reset,
    output reg red,
    output reg yellow,
    output reg green
);
    // State encoding for the traffic light FSM
    localparam STATE_RED    = 2'b00;
    localparam STATE_GREEN  = 2'b01;
    localparam STATE_YELLOW = 2'b10;
    
    // Timer durations for each state (in slow tick counts)
    parameter RED_DURATION    = 5; // e.g., 5 ticks for red light
    parameter GREEN_DURATION  = 5; // e.g., 5 ticks for green light
    parameter YELLOW_DURATION = 2; // e.g., 2 ticks for yellow light

    reg [1:0] current_state;
    reg [31:0] timer;
    
    // Instance of the clock divider to generate a slow tick signal
    wire slow_tick;
    clock_divider clk_div (
        .clk(clk),
        .reset(reset),
        .slow_tick(slow_tick)
    );
    
    // FSM: State update and timer counting on every slow tick
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_RED;
            timer <= 0;
        end else if (slow_tick) begin
            case (current_state)
                STATE_RED: begin
                    if (timer < RED_DURATION - 1)
                        timer <= timer + 1;
                    else begin
                        timer <= 0;
                        current_state <= STATE_GREEN;
                    end
                end
                STATE_GREEN: begin
                    if (timer < GREEN_DURATION - 1)
                        timer <= timer + 1;
                    else begin
                        timer <= 0;
                        current_state <= STATE_YELLOW;
                    end
                end
                STATE_YELLOW: begin
                    if (timer < YELLOW_DURATION - 1)
                        timer <= timer + 1;
                    else begin
                        timer <= 0;
                        current_state <= STATE_RED;
                    end
                end
                default: begin
                    current_state <= STATE_RED;
                    timer <= 0;
                end
            endcase
        end
    end

    // Combinational block to drive the outputs based on the current state
    always @(*) begin
        // Default all outputs off.
        red = 0;
        green = 0;
        yellow = 0;
        case (current_state)
            STATE_RED:    red = 1;
            STATE_GREEN:  green = 1;
            STATE_YELLOW: yellow = 1;
        endcase
    end
endmodule
