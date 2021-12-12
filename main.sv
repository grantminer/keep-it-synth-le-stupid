`default_nettype none

module main (sysclk, ena, buttons, rgb, signal);

parameter SYS_CLK_HZ = 12_000_000.0; // aka ticks per second
parameter SYS_CLK_PERIOD_NS = (1_000_000_000.0/SYS_CLK_HZ);
parameter CLK_HZ = 5*SYS_CLK_HZ; // aka ticks per second
parameter CLK_PERIOD_NS = (1_000_000_000.0/CLK_HZ); // Approximation.

input wire sysclk;
input wire ena;
wire clk;
input wire [1:0] buttons;
output logic [11:0] signal;
output logic [2:0] rgb;
logic rst; always_comb rst = buttons[0];

wire [3:0] SQUARE_OUT;
wire [3:0] TRIANGLE_OUT;
wire [3:0] SAW_OUT;

wire debounced;
debouncer #(.BOUNCE_TICKS(250)) DEBOUNCE(
  .clk(clk), .rst(rst),
  .bouncy_in(buttons[1]),
  .debounced_out(debounced)
);

wire positive_edge;
wire negative_edge;
edge_detector EDGE_DETECTOR(
  .clk(clk), .rst(rst),
  .in(debounced), 
  .positive_edge(positive_edge),
  .negative_edge(negative_edge)
);

square_wave #(.N(8)) SQUARE_WAVE(
    .clk(clk), .rst(rst), .ena(ena), .out(SQUARE_OUT)
);

triangle_wave #(.N(4)) TRIANGLE_WAVE(
    .clk(clk), .rst(rst), .ena(ena), .out(TRIANGLE_OUT)
);

saw_wave #(.N(8)) SAW_WAVE(
    .clk(clk), .rst(rst), .ena(ena), .out(SAW_OUT)
);

enum logic [2:0] {
    S_IDLE,
    S_SQUARE,
    S_TRIANGLE,
    S_SAW,
    S_ERROR
} wave_state;

always_ff @(posedge clk) begin : wave_fsm
    if (rst) begin
        wave_state <= wave_state.first;
    end else begin
        if (positive_edge) begin
            case (wave_state)
                S_IDLE : begin
                    wave_state <= S_SQUARE;
                end
                S_SQUARE : begin
                    wave_state <= S_TRIANGLE;
                end
                S_TRIANGLE : begin
                    wave_state <= S_SAW;
                end
                S_SAW : begin
                    wave_state <= S_IDLE;
                end
                default : wave_state <= S_ERROR;
            endcase
        end
    end
end

always_comb begin
    case (wave_state)
        S_IDLE : begin
            signal = 8'b0;
            rgb = 3'b000;
        end
        S_SQUARE : begin
            signal = SQUARE_OUT;
            rgb = 3'b110;
        end
        S_TRIANGLE : begin
            signal = TRIANGLE_OUT;
            rgb = 3'b101;
        end
        S_SAW : begin
            signal = SAW_OUT;
            rgb = 3'b011;
        end
        S_ERROR : begin
            signal = 8'b0;
            rgb = 3'b100;
        end
    endcase
end

endmodule
