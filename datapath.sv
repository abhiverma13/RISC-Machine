module datapath(
    clk,
    readnum,
    vsel,
    loada,
    loadb,
    shift,
    asel,
    bsel,
    ALUop,
    loadc,
    loads,
    writenum,
    write,
    datapath_out,
    mdata,
    sximm8,
    sximm5,
    PC,
    status
);

    input clk;
    input [2:0] readnum;
    input [1:0] vsel;    // Now 2 bits for 4 possible inputs
    input loada;
    input loadb;
    input [1:0] shift;
    input asel;
    input bsel;
    input [1:0] ALUop;
    input loadc;
    input loads;
    input [2:0] writenum;
    input write;
    input[15:0] mdata, sximm8, sximm5; // NEW
    input [8:0] PC; // NEW
    output [15:0] datapath_out;
    output [2:0] status; // NEW

    // Make regs!
    reg [15:0] datapath_out;

    // Instantiate various output wires
    wire [15:0] data_in;    // For Part 9
    wire [15:0] regB;       // For Part 4
    wire [15:0] data_out;   // For PART 1
    wire [15:0] regA;       // For PART 3
    wire [15:0] Ain;        // For PART 6
    wire [15:0] sout;       // For PART 8
    wire [15:0] Bin;        // For PART 7
    wire [15:0] out;        // For PART 2
    wire Z;                 // NEW For PART 2    
    wire V;                 // NEW For PART 2
    wire N;                 // NEW For PART 2

    // Instantiate reg file, Shifter, ALU
    regfile REGFILE(.data_in(data_in), .writenum(writenum), .write(write), .readnum(readnum), .clk(clk), .data_out(data_out));
    shifter U1(.in(regB), .shift(shift), .sout(sout));
    ALU U2(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z), .V(V), .N(N));

    // PART 9 // NEW added a 4 input mux to handle new inputs
    wire [15:0] PC_extended = {7'b0, PC};
    mux4x1_16bit MU4(.in0(datapath_out), .in1(PC_extended), .in2(sximm8), .in3(mdata), .sel(vsel), .out(data_in));
    
    // PART 3
    registerLDE #(16) regLDEA(.in(data_out), .load(loada), .clk(clk), .out(regA));

    // PART 4
    registerLDE #(16) regLDEB(.in(data_out), .load(loadb), .clk(clk), .out(regB));

    // PART 6
    assign Ain = (asel == 1'b1 ? 16'b0 : regA);   

    // PART 8
    // Done with sout wire in shifter

    // PART 7
    assign Bin = bsel ? sximm5 : sout;  // NEW. Handles sximm5

    // PART 2
    // Done with ALU unit instantiation

    // PART 5
    registerLDE #(16) regLDEC(.in(out), .load(loadc), .clk(clk), .out(datapath_out));

    // PART 10
    registerLDE #(3) regLDEStatus(.in({N, V, Z}), .load(loads), .clk(clk), .out(status));   // NEW types of statuses

endmodule
