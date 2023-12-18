module cpu_tb;

    // Declare reg and wire variables
    reg clk;
    reg reset, s, load;
    reg [15:0] read_data;
    reg [1:0] mem_cmd;
    reg [8:0] mem_addr;
    wire [15:0] out;
    wire N, V, Z, w;
    reg err = 1'b0;  // Error flag

    // Instantiate the cpu module
    cpu DUT(.clk(clk), .reset(reset), .s(s), .load(load), .read_data(read_data) , .out(out), .N(N), .V(V), .Z(Z), .w(w), .mem_cmd(mem_cmd), .mem_addr(mem_addr));

    initial begin
        clk = 0; #5;
        forever begin
          clk = 1; #5;
          clk = 0; #5;
        end
    end
    
    initial begin
        err = 0;
        reset = 1; s = 0; load = 0; read_data = 16'b0;
        #10;
        reset = 0; 
        #10;
        $display("state: %b", DUT.FSM.state);
    
        read_data = 16'b1101_0011_0000_1000;  // MOV R3, #8
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        if (DUT.DP.REGFILE.R3 !== 16'h8) begin
          err = 1;
          $display("FAILED: MOV R3, #8. R3: %b, PC: %b", DUT.DP.REGFILE.R3, DUT.PC);
          $stop;
        end
    
        @(negedge clk); // wait for falling edge of clock before changing inputs
        read_data = 16'b1101_0001_0000_1111; // MOV R1, #15
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        if (DUT.DP.REGFILE.R1 !== 16'hf) begin
          err = 1;
          $display("FAILED: MOV R1, #15");
          $stop;
        end
    
        @(negedge clk); // wait for falling edge of clock before changing inputs
        read_data = 16'b101_10_001_100_00_011;  // AND R4, R1, R3
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        if (DUT.DP.REGFILE.R4 !== 16'h8) begin
          err = 1;
          $display("FAILED: AND R4, R1, R3");
          $stop;
        end
        if (~err) $display("INTERFACE OK");

        // ----------------- CHECK 2 ----------------- //

        err = 0;
        reset = 1; s = 0; load = 0; read_data = 16'b0;
        #10;
        reset = 0; 
        #10;
    
        read_data = 16'b1101000000000011;  // MOV R0, #3
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        if (DUT.DP.REGFILE.R0 !== 16'h3) begin
          err = 1;
          $display("FAILED: MOV R0, #3");
          $stop;
        end
    
        @(negedge clk); // wait for falling edge of clock before changing inputs
        read_data = 16'b1101000100000011; // MOV R1, #3
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        if (DUT.DP.REGFILE.R1 !== 16'h3) begin
          err = 1;
          $display("FAILED: MOV R1, #3");
          $stop;
        end
    
        @(negedge clk); // wait for falling edge of clock before changing inputs
        read_data = 16'b101_01_001_000_00_001;  // CMP R1, R1
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        @(posedge DUT.PC or negedge DUT.PC);  // wait here until PC changes; autograder expects PC set to 1 *before* executing MOV R0, X
        if (DUT.N !== 1'b0 || DUT.V !== 1'b0 || DUT.Z !== 1'b1) begin
          err = 1;
          $display("FAILED: CMP R1, R1");
          $stop;
        end
        if (~err) $display("INTERFACE OK");

        $stop;
      end

endmodule
