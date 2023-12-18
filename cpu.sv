module cpu(clk,reset,s,load,read_data,out,N,V,Z,w,mem_cmd,mem_addr);
    input clk, reset, s, load;
    output [15:0] out;
    output [1:0] mem_cmd;
    output [8:0] mem_addr;
    input [15:0] read_data;
    output N, V, Z, w;
    
    // Wires for various places
    wire [15:0] outInstruction;                            // Instruction Register

    wire [2:0] nsel;                                       // Instruction Decoder
    wire [2:0] opcode;                                     // Instruction Decoder
    wire [1:0] op;                                         // Instruction Decoder
    wire [41:0] outDecoder;                                // Instruction Decoder ({ALUop, imm5, imm8, shift, readNum, writeNum})

    wire loada, loadb, loadc, loads, asel, bsel, write;    // Controller FSM
    wire [1:0] vsel;                                       // Controller FSM

    wire [1:0] ALUop;                                      // Datapath
    wire [15:0] imm5;                                      // Datapath
    wire [15:0] imm8;                                      // Datapath
    wire [1:0] shift;                                      // Datapath
    wire [2:0] readnum;                                    // Datapath
    wire [2:0] writenum;                                   // Datapath
    wire [8:0] PC;                                         // Datapath
    wire [2:0] status;                                     // Datapath
    wire [8:0] next_pc;                                    // NEW For Lab 7
    wire [8:0] out_pc_add1;                                // NEW For Lab 7
    wire load_pc;                                          // NEW For Lab 7 FSM
    wire reset_pc;                                         // NEW For Lab 7 FSM
    wire addr_sel;                                         // NEW For Lab 7 FSM
    wire load_ir;                                          // NEW For Lab 7 FSM
    wire load_addr;                                        // NEW For Lab 7 FSM
    wire [8:0] data_addr_out;                              // NEW For Lab 7 Stage 2
 
    // Instruction Register
    instructionRegister IR(.clk(clk), .in(read_data), .load(load_ir), .out(outInstruction));

    // Instruction Decoder
    instructionDecoder ID(.in(outInstruction), .nsel(nsel), .opcode(opcode), .op(op), .ALUop(ALUop), .imm5(imm5), .imm8(imm8), .shift(shift), .readnum(readnum), .writenum(writenum));

    // Controller Finite State Machine
    controllerFSM FSM(.clk(clk), .s(s), .reset(reset), .opcode(opcode), .op(op), .w(w), .nsel(nsel), .loada(loada), .loadb(loadb), .loadc(loadc), .loads(loads), .asel(asel), .bsel(bsel), .vsel(vsel), .write(write), .load_pc(load_pc), .reset_pc(reset_pc), .addr_sel(addr_sel), .mem_cmd(mem_cmd), .load_ir(load_ir), .load_addr(load_addr));

    // NEW PC Register with Load Enable
    registerLDE #(9) regLDEPC(.in(next_pc), .load(load_pc), .clk(clk), .out(PC));

    // NEW Add 1 to the out_pc
    addOne #(9) add(.in(PC), .out(out_pc_add1));

    // NEW 2 input 9 bits MUX for added PC to be loaded or not
    assign next_pc = reset_pc ? 9'b0 : out_pc_add1;

    // NEW 2 input 9 bits MUX for choosing next PC without added 1
    assign mem_addr = addr_sel ? PC : data_addr_out;

    // NEW Data Address with Load Enable
    registerLDE #(9) regLDEDataAddress(.in(out[8:0]), .load(load_addr), .clk(clk), .out(data_addr_out));

    // Datapath
    datapath DP(.clk(clk), .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb), .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc), .loads(loads), .writenum(writenum), .write(write), .datapath_out(out), .mdata(read_data), .sximm8(imm8), .sximm5(imm5), .PC(PC), .status(status));
    assign N = status[2];
    assign V = status[1];
    assign Z = status[0];
endmodule