module addOne(in, out);
    parameter  width = 8;
    input [width - 1 : 0] in;
    output [width - 1 : 0] out;
    reg [width - 1:0] out;

    // Add one to the input
    always @(in) begin
        out = in + 1'b1;
    end
endmodule