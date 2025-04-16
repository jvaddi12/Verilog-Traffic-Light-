`timescale 1ns / 1ps
module tb_traffic_light_controller;

    reg clk;
    reg reset;
    wire red, yellow, green;

    // Instantiate DUT (Design Under Test)
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Simulation control
    initial begin
        reset = 1;
        #50;
        reset = 0;
      #10000000;
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light_controller);
    end

endmodule
