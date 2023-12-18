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
`define DATAADRESS 5'b10110
`define DATAADRESSSTR 5'b11000
`define READLDR 5'b10000
`define READLDR2 5'b10111   
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

module controllerFSM(clk, s, reset, opcode, op, w, nsel, loada, loadb, loadc, loads, asel, bsel, vsel, write, load_pc, reset_pc, addr_sel, mem_cmd, load_ir, load_addr);
    input s, reset, clk;
    input [2:0] opcode;
    input [1:0] op;
    output reg w, write, loada, loadb, loadc, loads, asel, bsel, load_pc, reset_pc, addr_sel, load_ir, load_addr;
    output reg [2:0] nsel;
    output reg [1:0] vsel, mem_cmd;

    // Make state variables
    reg [4:0] state; 
    reg [4:0] reset_state;
    reg [4:0] next_state;

    // Hold the next state in the reset_state
    assign reset_state = reset ? `RST : next_state;

    // Only change the state at the clock edge
    always @(posedge clk) begin
        state = reset_state;
    end

    // Keep the next_state changed to what it should be on clock edge
    always @* begin     
        casex({state,s,opcode,op})
            {`RST, 6'bx_xxx_xx}: begin // Need only clock to change and fetch instruction
                next_state = `IF1;
            end
            {`IF1, 6'bx_xxx_xx}: begin // Same only needs clock to fetch instruction
                next_state = `IF2;
            end
            {`IF2, 6'bx_xxx_xx}: begin // Now update PC state after instruction fetch
                next_state = `UPDATEPC;
            end
            {`UPDATEPC, 6'bx_xxx_xx}: begin // Decode instruction after fetched and PC updated
                next_state = `DECODE;
            end
            {`DECODE, 6'bx_111_xx}: begin   // Self loop halt
                next_state = `DECODE;
            end
            {`DECODE, 6'bx_110_10}: begin   // If op is 10 and opcode is 110 then its a MOV
                next_state = `WRITEIMM;
            end
            {`DECODE, 6'bx_011_00}: begin   // If op is 00 and opcode is 011 then its a LDR
                next_state = `GETA;
            end
            {`DECODE, 6'bx_100_00}: begin   // If op is 00 and opcode is 100 then its a STR
                next_state = `GETA;
            end
            {`ADDLDR, 6'bx_011_00}: begin   // Now write answer to Rd
                next_state = `DATAADRESS;
            end
            {`DATAADRESS, 6'bx_011_00}: begin   // Now write answer to Rd
                next_state = `READLDR;
            end
            {`READLDR, 6'bx_011_00}: begin   // Now write answer to Rd
                next_state = `READLDR2;
            end
            {`READLDR2, 6'bx_011_00}: begin   // After writing Rd go back and fetch new instruction
                next_state = `IF1;
            end
            {`ADDSTR, 6'bx_100_00}: begin   // Now write answer to 
                next_state = `DATAADRESSSTR;
            end
            {`DATAADRESSSTR, 6'bx_100_00}: begin   // Now write answer to 
                next_state = `GETRD;
            end
            {`GETRD, 6'bx_100_00}: begin   // Put rd into B
                next_state = `GETEMPTYADD;
            end
            {`GETEMPTYADD, 6'bx_100_00}: begin   // Now output Rd on datapath_out
                next_state = `OUTRD;
            end
            {`OUTRD, 6'bx_100_00}: begin   // Fetch next instruction
                next_state = `IF1;
            end
            {`GETA, 6'bx_011_00}: begin   // Add the sximm5 with bsel
                next_state = `ADDLDR;
            end
            {`GETA, 6'bx_100_00}: begin   // Add the sximm5 with bsel
                next_state = `ADDSTR;
            end
            {`WRITEIMM, 6'bx_xxx_xx}: begin // After writing the immediate fetch new instruction
                next_state = `IF1;
            end
            {`DECODE, 6'bx_xxx_xx}: begin 
                next_state = `GETB; // Do get B first since at least Rm is needed
            end
            {`GETB, 6'bx_110_00}: begin // If op is 00 and opcode is 110 then its a MOV
                next_state = `MOV;
            end
            {`MOV, 6'bx_110_00}: begin  // After moving write it to Rd
                next_state = `WRITEREG;
            end
            {`GETB, 6'bx_101_11}: begin // If op is 11 and opcode is 101 then MVN requirs only B
                next_state = `MVN;
            end
            {`MVN, 6'bx_xxx_xx}: begin
                next_state = `WRITEREG; // Dont need another number for MVN so write it
            end
            {`GETB, 6'bx_101_xx}: begin // If op is 01 and opcode is 101 the another number A is required
                next_state = `GETA;
            end 
            {`GETA, 6'bx_xxx_00}: begin // op 00 is adding
                next_state = `ADD;  
            end
            {`GETA, 6'bx_xxx_01}: begin // op 01 is comapring
                next_state = `CMP;
            end
            {`GETA, 6'bx_xxx_10}: begin // op 10 is bitwise &
                next_state = `AND;
            end
            {`ADD, 6'bx_xxx_xx}: begin  // After add write to rd reg
                next_state = `WRITEREG;
            end
            {`AND, 6'bx_xxx_xx}: begin  // After and write to rd reg
                next_state = `WRITEREG;
            end
            {`CMP, 6'bx_xxx_xx}: begin
                next_state = `IF1; // Only changes the flags so doesnt need write reg
            end
            {`WRITEREG, 6'bx_xxx_xx}: begin // After writing to reg go back and fetch new instruction
                next_state = `IF1;
            end
            default: next_state = 5'bx;  // If nothing matches then stay in current state
        endcase
    end

    // Change outputs depending on state
    always @* begin
        casex(state)
            `ADDSTR: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_0_1_000_0_0_0_0_0_0_10_1;
            end
            `GETRD: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_1_0_00_0_0_010_0_0_0_0_0_0_10_1;
            end
            `GETEMPTYADD: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_1_0_000_0_0_0_0_0_0_10_0;
            end
            `OUTRD: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_0_0_000_0_0_0_0_0_0_10_0;
            end
            `ADDLDR: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_0_1_000_0_0_0_0_0_0_01_1;
            end
            `DATAADRESS: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_000_0_0_0_0_0_0_01_1;
            end
            `DATAADRESSSTR: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_000_0_0_0_0_0_0_10_1;
            end
            `READLDR: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_11_0_0_010_0_1_0_0_0_0_01_0;
            end
            `READLDR2: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_11_0_0_010_0_1_0_0_0_0_01_0;
            end
            `RST: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_000_0_0_1_1_0_0_00_0;
            end
            `IF1: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_000_0_0_0_0_1_0_01_0;    // 01 is `MREAD
            end
            `IF2: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_000_0_0_0_0_1_1_01_0;    // 01 is `MREAD
            end
            `UPDATEPC: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_000_0_0_1_0_0_0_00_0;
            end
            `DECODE: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_000_0_0_0_0_0_0_00_0;
            end
            `MOV: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_1_0_000_0_0_0_0_0_0_00_0;
            end
            `WRITEIMM: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_10_0_0_001_0_1_0_0_0_0_00_0;
            end
            `GETA: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_1_0_0_00_0_0_001_0_0_0_0_0_0_00_0;
            end
            `GETB: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_1_0_00_0_0_100_0_0_0_0_0_0_00_0;
            end
            `ADD: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_0_0_000_0_0_0_0_0_0_00_0;
            end
            `WRITEREG: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_0_00_0_0_010_0_1_0_0_0_0_00_0;
            end
            `MVN: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_0_0_000_0_0_0_0_0_0_00_0; // Taken care of by ALUop
            end
            `CMP: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_0_0_000_1_0_0_0_0_0_00_0;  // Currently writes into C but never write reg after
            end
            `AND: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'b0_0_0_1_00_0_0_000_0_0_0_0_0_0_00_0;
            end
            default: begin
                {w,loada,loadb,loadc,vsel,asel,bsel,nsel,loads,write,load_pc,reset_pc,addr_sel,load_ir,mem_cmd,load_addr}  = 20'bx;
            end
        endcase 
    end


endmodule
