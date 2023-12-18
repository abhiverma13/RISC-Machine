module registerLDE(in, load, clk, out);
    parameter n = 1; // Width
    input [n - 1:0] in;
    input load, clk;
    output [n - 1:0] out;
    reg [n - 1:0] out;
    wire [n - 1:0] next_out;

    assign next_out = load ? in : out;

    // Sequential logic
    always @(posedge clk) begin
        out <= next_out;
    end

endmodule