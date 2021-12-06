`default_nettype none
`timescale 1ns/1ps

module test_square_wave;

    parameter N = 8;

    logic clk, ena, rst;

    wire [$clog2(N-1):0] out;

    square_wave UUT(.clk(clk), .rst(rst), .ena(ena), .out(out));

    initial begin
        $dumpfile("results/test_square.vcd");
        $dumpvars(0, UUT);
        
        clk = 0;
        rst = 1;
        ena = 1;

        repeat (2) @(negedge clk);
        rst = 0;
        
        repeat (100) @(posedge clk);
        ena = 0;

        repeat (20) @(posedge clk);

        $finish;
    end

    always #5 clk = ~clk;

endmodule