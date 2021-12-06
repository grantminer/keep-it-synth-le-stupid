`default_nettype none

module saw_wave(clk, rst, ena, out);

    parameter N = 8;

    input wire clk, rst, ena;

    output logic [$clog2(N-1):0] out;
    logic [$clog2(N-1):0] q;

    always_ff @(posedge clk) begin
        if (rst) q <= 0;
        out <= q;
    end

    always_comb begin
        if (N & q) q = 0;
        if (ena) q = out + 1;
    end

endmodule