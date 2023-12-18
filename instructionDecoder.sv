module instructionDecoder(in, nsel, opcode, op, ALUop, imm5, imm8, shift, readnum, writenum);
    input [15:0] in;
    input [2:0] nsel;          // 3 bits for 8 register choosing
    output reg [2:0] opcode;
    output reg [1:0] op;
    output reg [1:0] shift;
    output reg [15:0] imm8;
    output reg [15:0] imm5;
    output reg [1:0] ALUop;
    output reg [2:0] readnum;
    output reg [2:0] writenum;
 

    // Make wires for the Rn, Rd, Rm
    reg [2:0] Rn;
    reg [2:0] Rd;
    reg [2:0] Rm;

    always @(in) begin
        opcode = in[15:13]; // Extract opcode from instruction. This is ADD, MOV, etc
        op = in[12:11]; 
        ALUop = in[12:11];  // Extract ALUop code

        // Aregs for the operations
        Rn = in[10:8];
        Rd = in[7:5];
        Rm = in[2:0];

        // Get the shift
        shift = in[4:3];

        // Do sign extension
        imm8 = {{8{in[7]}}, in[7:0]};
        imm5 = {{11{in[4]}}, in[4:0]};
    end

    // Always combinational for picking R when nsel changes
    // nsel is one hot
    // nsel = 001 -> Rn, 010 -> Rd, 100 -> Rm
    always @ (*) begin
        case (nsel)
            3'b001: begin
                readnum = Rn;
                writenum = Rn;
            end
            3'b010: begin
                readnum = Rd;
                writenum = Rd;
            end
            3'b100: begin
                readnum = Rm;
                writenum = Rm;
            end
            default: begin
                readnum = 3'bx;
                writenum = 3'bx;
            end
        endcase
    end

endmodule
