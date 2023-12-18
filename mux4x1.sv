module mux4x1_16bit(in0, in1, in2, in3, sel, out);

    input [15:0] in0;  // Input 0
    input [15:0] in1;  // Input 1
    input [15:0] in2;  // Input 2
    input [15:0] in3;  // Input 3
    input [1:0] sel;   // Select input
    output [15:0] out;  // Output
    reg [15:0] out;    // Output

    always @* begin
        case(sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 16'bxxxx;
        endcase
    end

endmodule
