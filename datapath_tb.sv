module datapath_tb;

    // Declare reg and wire variables
    reg clk;
    reg [2:0] readnum;
    reg [1:0] vsel;    // Now 2 bits for 4 possible inputs
    reg loada;
    reg loadb;
    reg [1:0] shift;
    reg asel;
    reg bsel;
    reg [1:0] ALUop;
    reg loadc;
    reg loads;
    reg [2:0] writenum;
    reg write;
    wire [15:0] datapath_out;
    reg [15:0] mdata, sximm8, sximm5;
    reg [7:0] PC;
    wire [2:0] status;

    // Instantiate the datapath module
    datapath DUT(.clk(clk), .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb), .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc), .loads(loads), .writenum(writenum), .write(write), .datapath_out(datapath_out), .mdata(mdata), .sximm8(sximm8), .sximm5(sximm5), .PC(PC), .status(status));

    // Error flag
    reg err = 0;

    initial begin
        // Set everything to sumting
        clk = 1'b0;
        readnum = 3'b0;
        vsel = 2'b00;
        loada = 1'b0;
        loadb = 1'b0;
        shift = 2'b0;
        asel = 1'b0;
        bsel = 1'b0;
        ALUop = 2'b0;
        loadc = 1'b0;
        loads = 1'b0;
        writenum = 3'b0;
        write = 1'b0;
        mdata = 16'b0;
        sximm8 = 16'b0;
        sximm5 = 16'b0;
        PC = 8'b0;

        /** CYCLE 1 ----- READ 13 INTO A ----- MOV R2, #13 */
        #2 vsel = 2'b10;

        // First Write to R2 the value 13
        #2 writenum = 3'b010;   // Register 2
        #2 write = 1'b1;
        #2 sximm8 = 16'b0000_0000_0000_1101;   // 13
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        // Read the value into A
        #2 write = 1'b0;
        #2 readnum = 3'b010;    // Register 2
        #2 loada = 1'b1;
        #2 clk = 1'b1;
        #2 clk = 1'b0;
        
        /** CYCLE 2 ----- READ 42 INTO B ----- MOV R3, #42 */
        // First Write to R3 the value 42
        #2 loada = 1'b0;
        #2 writenum = 3'b011;   // Register 3
        #2 write = 1'b1;
        #2 sximm8 = 16'b0000_0000_0010_1010;   // 1342
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        // Read the value into B
        #2 write = 1'b0;
        #2 readnum = 3'b011;    // Register 3
        #2 loadb = 1'b1;
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        /** CYCLE 3 ----- EXECUTION OF ADDITION ----- ADD R5, R3, R2 */
        #2 loadb = 1'b0;
        #2 asel = 1'b0;
        #2 bsel = 1'b0;
        #2 ALUop = 2'b00;    // Add
        #2 shift = 2'b00;    // No shift
        #2 loadc = 1'b1;    // Load into C
        #2 clk = 1'b1;      // Clock cycle to set the register for c
        #2 clk = 1'b0;

        /** CYCLE 4 ----- SAVE 55 INTO R5 ----- PART OF ADD R5, R3, R2 */
        #2 loadc = 1'b0;
        #2 vsel = 2'b00;
        #2 writenum = 3'b101;   // Register 5
        #2 write = 1'b1;
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        $display("Result: %d", datapath_out);


        /** -------------------------- EXAMPLE IN LAB 5 -------------------------- */
        // Set everything to 0 initially
        #2 clk = 1'b0;
        #2 readnum = 3'b0;
        #2 vsel = 2'b00;
        #2 loada = 1'b0;
        #2 loadb = 1'b0;
        #2 shift = 2'b0;
        #2 asel = 1'b0;
        #2 bsel = 1'b0;
        #2 ALUop = 2'b0;
        #2 loadc = 1'b0;
        #2 loads = 1'b0;
        #2 writenum = 3'b0;
        #2 write = 1'b0;
        #2 mdata = 16'b0;
        #2 sximm8 = 16'b0;
        #2 sximm5 = 16'b0;
        #2 PC = 8'b0;
       

        /** CYCLE 1 ----- READ 7 INTO B ----- MOV R0, #7 */
        #2 vsel = 2'b10;

        // First Write to R0 the value 7
        #2 writenum = 3'b000;   // Register 0
        #2 write = 1'b1;
        #2 sximm8 = 16'b0000_0000_0000_0111;   // 7
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        // Read the value into A
        #2 write = 1'b0;
        #2 readnum = 3'b000;    // Register 1
        #2 loadb = 1'b1;
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        /** CYCLE 2 ----- READ 42 INTO A ----- MOV R1, #2 */
        // First Write to R1 the value 2
        #2 loadb = 1'b0;
        #2 writenum = 3'b001;   // Register 1
        #2 write = 1'b1;
        #2 sximm8 = 16'b0000_0000_0000_0010;   // 2
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        // Read the value into B
        #2 write = 1'b0;
        #2 readnum = 3'b001;    // Register 1
        #2 loada = 1'b1;
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        /** CYCLE 3 ----- EXECUTION OF ADDITION WITH SHIFT LEFT 1 ----- ADD R2, R1, R0, LSL #1 */
        #2 loada = 1'b0;
        #2 asel = 1'b0;
        #2 bsel = 1'b0;
        #2 ALUop = 2'b00;    // Add
        #2 shift = 2'b01;    // SHIFT 1 bit left
        #2 loadc = 1'b1;    // Load into C
        #2 clk = 1'b1;      // Clock cycle to set the register for c
        #2 clk = 1'b0;

        /** CYCLE 4 ----- SAVE 55 INTO R5 ----- PART OF ADD R2, R1, R0, LSL #1 */
        #2 loadc = 1'b0;
        #2 vsel = 2'b00;
        #2 writenum = 3'b101;   // Register 5
        #2 write = 1'b1;
        #2 clk = 1'b1;
        #2 clk = 1'b0;

        // Expect this to be 16
        $display("Result: %d", datapath_out);

        // Finish simulation before time 500
        #300 $stop;
    end

    always @(negedge err) begin
        if (err)
            $display("Test failed!");
    end

endmodule