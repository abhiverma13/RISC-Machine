module instructionRegister_tb;

    // Declare reg and wire variables
    reg clk;
    reg [15:0] in;
    reg load;
    wire [15:0] out;
    reg err = 1'b0;  // Error flag
    reg [15:0] expected_out;

    // Instantiate the instructionRegister module
    instructionRegister DUT(.clk(clk), .in(in), .load(load), .out(out));

    
    // Create a clock signal
    initial forever begin
        #2 clk = 1'b0;
        #2 clk = 1'b1;
    end


    initial begin
        // Set initial values
        clk = 1'b0; 
        in = 16'b0;
        load = 1'b0;

        // Test sequence
        #3 in = 16'b1010_1010_1010_1010; 
        #7 load = 1'b1;  // Load a new instruction
        #7 load = 1'b0;  // Stop loading
        if (out !== in) begin
            err <= 1'b1;
            $display("Error: expected %b, got %b", expected_out, out);
        end
        #7 in = 16'b0101_0101_0101_0101;
        #7 load = 1'b1;  // Load another instruction
        #7 load = 1'b0;  // Stop loading
        if (out !== in) begin
            err <= 1'b1;
            $display("Error: expected %b, got %b", expected_out, out);
        end
        
        $stop;
    end
endmodule
