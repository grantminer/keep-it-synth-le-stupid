module square_wave (clk, rst, ena, out);

    parameter N = 8;

    input wire clk, rst, ena;

    output logic [$clog2(N-1):0] out = 0;
    logic [$clog2(N-1):0] q, mid;

    logic square;

    always_ff @(posedge clk) begin
        if (rst) q <= 0;
        mid <= q;
    end

    always_comb begin
        square = N == q;
        if (N & q) q = 0;
        if (ena) q = mid + 1;
    end

    always_ff @(posedge square) begin
        out <= ~out;
    end

endmodule