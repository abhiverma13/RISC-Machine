module shifter(in, shift, sout);
    input [15:0] in;
    input [1:0] shift;
    output [15:0] sout;

    // Reg the output
    reg [15:0] sout;

    // Combinational
    always @(*) begin
        case (shift)
            2'b00: sout = in; 
            2'b01: sout = in << 1;
            2'b10: sout = {1'b0, in[15:1]}; // Shift right, MSB is 0
            2'b11: sout = {in[15], in[15:1]}; // Shift right, MSB is copy of in[15] For sign extension
        endcase
    end
endmodule
