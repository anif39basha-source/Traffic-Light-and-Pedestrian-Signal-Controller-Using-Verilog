`timescale 1ns / 1ps

module tb_traffic_light_ped;

    reg clk;
    reg reset;
    reg ped_btn;
    wire [2:0] veh_light;
    wire [1:0] ped_light;

    // Instantiate DUT
    traffic_light_ped uut (
        .clk(clk),
        .reset(reset),
        .ped_btn(ped_btn),
        .veh_light(veh_light),
        .ped_light(ped_light)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz in sim
    end

    // Stimulus
    initial begin
        // Initialize
        reset = 1;
        ped_btn = 0;
        #20;
        reset = 0;

        // Wait some time in vehicle green
        #100;

        // Pedestrian presses button
        ped_btn = 1;
        #20;
        ped_btn = 0;

        // Let the sequence complete
        #300;

        // Second pedestrian request later
        #100;
        ped_btn = 1;
        #20;
        ped_btn = 0;

        #500;
        $stop;  // end simulation
    end

endmodule