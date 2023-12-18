// To ensure Quartus uses the embedded MLAB memory blocks inside the Cyclone
// V on your DE1-SoC we follow the coding style from in Altera's Quartus II
// Handbook (QII5V1 2015.05.04) in Chapter 12, “Recommended HDL Coding Style”
//
// 1. "Example 12-11: Verilog Single Clock Simple Dual-Port Synchronous RAM 
//     with Old Data Read-During-Write Behavior" 
// 2. "Example 12-29: Verilog HDL RAM Initialized with the readmemb Command"


// EXAMPLE:
// MOV R0, #7 // this means, take the absolute number 7 and store it in R0
// MOV R1, #2 // this means, take the absolute number 2 and store it in R1
// ADD R2, R1, R0, LSL#1 // this means R2 = R1 + (R0 shifted left by 1) = 2+14=16

// @00 1101000000000111
// @01 1101000100000010
// @02 1010000101001000


module RAM(clk,read_address,write_address,write,din,dout);
    parameter data_width = 32; 
    parameter addr_width = 4;
    parameter filename = "data.txt";

    input clk;
    input [addr_width-1:0] read_address, write_address;
    input write;
    input [data_width-1:0] din;
    output [data_width-1:0] dout;
    reg [data_width-1:0] dout;

    reg [data_width-1:0] mem [2**addr_width-1:0];

    initial $readmemb(filename, mem);

    always @ (posedge clk) begin
        if (write)
            mem[write_address] <= din;
        dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                                   // (this is due to Verilog non-blocking assignment "<=")
    end 
endmodule
