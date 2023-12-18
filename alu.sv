module ALU(Ain, Bin, ALUop, out, Z, V, N);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output [15:0] out;
    output Z;
    output reg V;
    output reg N;

    // Make outputs regs
    reg [15:0] out;
    reg Z;

    always @(*) begin
        case (ALUop)
            2'b00: out = Ain + Bin; // Addition
            2'b01: out = Ain - Bin; // Subtraction
            2'b10: out = Ain & Bin; // Bitwise AND
            2'b11: out = ~Bin;      // Bitwise NOT
        endcase

        // Set Z if out is zero
        if (out == 16'b0) begin
            Z = 1'b1;
        end else begin
            Z = 1'b0;
        end

        // Set V if out overflows
        if ((Ain[15] == Bin[15]) && (out[15] != Ain[15])) begin
            V = 1'b1;
        end else begin
            V = 1'b0;
        end

        // Set N if out is negative
        if (out[15] == 1'b1) begin
            N = 1'b1;
        end else begin
            N = 1'b0;
        end
    end
endmodule
