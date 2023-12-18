module instructionDecoder_tb;

    // Declare reg and wire variables
    reg clk;
    reg [15:0] in;
    reg [2:0] nsel;
    wire [2:0] opcode;
    wire [1:0] op;
    wire [1:0] shift;
    wire [15:0] imm8;
    wire [15:0] imm5;
    wire [1:0] ALUop;
    wire [2:0] readnum;
    wire [2:0] writenum;
    reg err = 1'b0;  // Error flag

    // Instantiate the instructionDecoder module
    instructionDecoder DUT(.in(in), .nsel(nsel), .opcode(opcode), .op(op), .shift(shift), .imm8(imm8), .imm5(imm5), .ALUop(ALUop), .readnum(readnum), .writenum(writenum));

    initial begin
        // Set initial values
        in = 16'b0;
        nsel = 3'b0;

        // in = opcode_op_Rn_Rd_shift_Rm
        // Test sequence
        #1 in = 16'b110_10_000_000_00_111; 
        #1 nsel = 3'b001;  // Test instruction 1
        // Check if the outputs are correct
        if (opcode != 3'b110 && op != 2'b10 && ALUop != 2'b10 && shift != 2'b00 && readnum != 3'b000) begin
            err <= 1'b1;
            $display("Error: outputs are not as expected");
        end
        #1 in = 16'b101_01_010_101_01_010; 
        #1 nsel = 3'b010;  // Test instruction 2
        if (opcode != 3'b101 && op != 2'b01 && ALUop != 2'b01 && shift != 2'b01 && readnum != 3'b101) begin
            err <= 1'b1;
            $display("Error: outputs are not as expected");
        end
        #1 $stop;  // End the simulation
    end

endmodule
