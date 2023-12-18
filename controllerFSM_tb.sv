// State constants
`define GETA 5'b00001
`define GETB 5'b00010
`define DECODE 5'b00011
`define ADD 5'b00100  
`define CMP 5'b00101
`define AND 5'b00110
`define MVN 5'b00111
`define WRITEREG 5'b01000
`define WRITEIMM 5'b01001
`define MOV 5'b01010
`define RST 5'b01011
`define IF1 5'b01100
`define IF2 5'b01101
`define UPDATEPC 5'b01110
`define ADDLDR 5'b01111 
`define READLDR 5'b10000   
`define ADDSTR 5'b10001
`define GETRD 5'b10011
`define GETEMPTYADD 5'b10101
`define OUTRD 5'b10100

// nsel constants
`define RN 3'b001
`define RD 3'b010
`define RM 3'b100

// Lab 7 memory constants
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10

module controllerFSM_tb;

    // Declare reg and wire variables
    reg clk;
    reg s, reset;
    reg [2:0] opcode;
    reg [1:0] op;
    wire w, write, loada, loadb, loadc, loads, asel, bsel, load_pc, reset_pc, addr_sel, load_ir, load_addr;
    wire [2:0] nsel;
    wire [1:0] vsel;
    wire [1:0] mem_cmd;
    reg err = 1'b0;  // Error flag

    // Instantiate the controllerFSM module
    controllerFSM DUT(.clk(clk), .s(s), .reset(reset), .opcode(opcode), .op(op), .w(w), .nsel(nsel), .loada(loada), .loadb(loadb), .loadc(loadc), .loads(loads), .asel(asel), .bsel(bsel), .vsel(vsel), .write(write), .load_pc(load_pc), .reset_pc(reset_pc), .addr_sel(addr_sel), .mem_cmd(mem_cmd), .load_ir(load_ir), .load_addr(load_addr));

    initial forever begin
        #2 clk = 1'b0;
        #2 clk = 1'b1;
    end

    initial begin
        // Set initial values
        s = 1'b0;
        reset = 1'b0;
        opcode = 3'b0;
        op = 2'b0;


        // GO THROUGH STEPS TO GET TO ADD AND THEN WRITE REG
        #2 reset = 1'b1;
        #4;
        $display("out state = %b", DUT.state);
        reset = 1'b0;
        if (DUT.state != `RST) begin
            err <= 1'b1;
            $display("1 state = %b", DUT.state);
        end

        // Test sequence
        #4; // clk
        if (DUT.state != `IF1) begin
            err <= 1'b1;
            $display("1.1 state = %b", DUT.state);
        end

        #4; // clk
        if (DUT.state != `IF2) begin
            err <= 1'b1;
            $display("1.2 state = %b", DUT.state);
        end

        #4; // clk
        if (DUT.state != `UPDATEPC) begin
            err <= 1'b1;
            $display("1.3 state = %b", DUT.state);
        end

        #4; // clk
        if (DUT.state != `DECODE) begin
            err <= 1'b1;
            $display("1.4 state = %b", DUT.state);
        end

        // Start instruction 1
        opcode = 3'b101; 
        op = 2'b00;  // Test instruction 1
        #4;
        if (DUT.state != `GETB) begin
            err <= 1'b1;
            $display("3 state = %b", DUT.state);
        end

        #4;
        if (DUT.state != `GETA) begin
            err <= 1'b1;
            $display("4 state = %b", DUT.state);
        end

        #4;
        if (DUT.state != `ADD) begin
            err <= 1'b1;
            $display("5 state = %b", DUT.state);
        end

        #4;
        if (DUT.state != `WRITEREG) begin
            err <= 1'b1;
            $display("6 state = %b", DUT.state);
        end

        #5 $stop;
    end
endmodule
