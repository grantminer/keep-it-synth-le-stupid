module triangle_wave (clk, rst, ena, out);

parameter N = 8;

input wire clk, rst, ena;

output logic [$clog2(N-1):0] out;

endmodule