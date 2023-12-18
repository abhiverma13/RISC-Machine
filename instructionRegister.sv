module instructionRegister(clk, in, load, out);
    input [15:0] in;
    input clk, load;
    output reg [15:0] out;

    // When clock we take in the new instructions
    always @(posedge clk) begin
        if (load) begin
            out <= in;
        end else begin
            out <= out;
        end
    end
endmodule
