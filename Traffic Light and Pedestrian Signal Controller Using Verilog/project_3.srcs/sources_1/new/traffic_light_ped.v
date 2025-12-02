`timescale 1ns / 1ps

module traffic_light_ped (
    input  wire       clk,
    input  wire       reset,
    input  wire       ped_btn,
    output reg  [2:0] veh_light,  // {R,Y,G}
    output reg  [1:0] ped_light   // {R,G}
);

    // State encoding
    localparam S_VEH_GREEN = 2'b00;
    localparam S_VEH_YELLOW = 2'b01;
    localparam S_PED_GREEN = 2'b10;
    localparam S_ALL_RED = 2'b11;

    reg [1:0] state, next_state;

    // Timing parameters (for simulation use small values)
    localparam integer GREEN_TICKS    = 10;  // vehicle green duration
    localparam integer YELLOW_TICKS   = 5;   // yellow duration
    localparam integer PED_TICKS      = 10;  // pedestrian green duration
    localparam integer ALL_RED_TICKS  = 5;   // all red duration

    reg [7:0] timer;   // simple counter for timing
    reg       ped_req; // latched pedestrian request

    // 1) Pedestrian request latch
    // once button is pressed, remember it until served
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ped_req <= 1'b0;
        end else begin
            // latch request only in vehicle-green state
            if (state == S_VEH_GREEN) begin
                if (ped_btn)
                    ped_req <= 1'b1;
                // will be cleared when we leave PED_GREEN state
            end else if (state == S_PED_GREEN) begin
                ped_req <= 1'b0; // request served
            end
        end
    end

    // 2) State register + timer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_VEH_GREEN;
            timer <= 0;
        end else begin
            if (state != next_state) begin
                // state change -> reset timer
                state <= next_state;
                timer <= 0;
            end else begin
                // stay in same state -> increment timer
                timer <= timer + 1;
            end
        end
    end

    // 3) Next-state logic
    always @(*) begin
        next_state = state;  // default

        case (state)
            S_VEH_GREEN: begin
                // after minimum green AND ped requested -> go to yellow
                if ((timer >= GREEN_TICKS) && ped_req)
                    next_state = S_VEH_YELLOW;
                else
                    next_state = S_VEH_GREEN;
            end

            S_VEH_YELLOW: begin
                if (timer >= YELLOW_TICKS)
                    next_state = S_PED_GREEN;
            end

            S_PED_GREEN: begin
                if (timer >= PED_TICKS)
                    next_state = S_ALL_RED;
            end

            S_ALL_RED: begin
                if (timer >= ALL_RED_TICKS)
                    next_state = S_VEH_GREEN;
            end

            default: next_state = S_VEH_GREEN;
        endcase
    end

    // 4) Output logic (depends only on state)
    always @(*) begin
        case (state)
            S_VEH_GREEN: begin
                veh_light = 3'b001; // G
                ped_light = 2'b10;  // R
            end

            S_VEH_YELLOW: begin
                veh_light = 3'b010; // Y
                ped_light = 2'b10;  // R
            end

            S_PED_GREEN: begin
                veh_light = 3'b100; // R
                ped_light = 2'b01;  // G
            end

            S_ALL_RED: begin
                veh_light = 3'b100; // R
                ped_light = 2'b10;  // R
            end

            default: begin
                veh_light = 3'b100; // fail safe: all red
                ped_light = 2'b10;
            end
        endcase
    end

endmodule