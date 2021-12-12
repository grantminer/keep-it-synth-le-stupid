`timescale 1ns / 100ps
`default_nettype none
`define SIMULATION
module test_main;
parameter CLK_HZ = 12_000_000;
parameter CLK_PERIOD_NS = (1_000_000_000/CLK_HZ); // Approximation.
//Module I/O and parameters
logic clk;
logic [1:0] buttons;
wire [1:0] leds;
wire [2:0] rgb;

main UUT(clk, ena, buttons, rgb, signal);

ft6206_model FT6206_MODEL (buttons[0], touch_i2c_scl, touch_i2c_sda);

logic [63:0] cycles_to_run = CLK_HZ*25; // Run for one second.

// Run our main clock.
always #(CLK_PERIOD_NS/2) clk = ~clk;

initial begin
  // Collect waveforms
  $dumpfile("main.vcd");
  $dumpvars(0, UUT);
  $display("Running test main...");
  // $dumplimit(100_000_000); // Enable this if you are low on space!
  // Initialize module inputs.
  clk = 0;
  buttons = 2'b11; //using button[0] as reset.
  // Assert reset for long enough.
  repeat(2) @(negedge clk);
  buttons = 2'b00;
  $display("Running for %d clock cycles. ", cycles_to_run);
  repeat (cycles_to_run) @(posedge clk); 
  $finish;
end

endmodule
