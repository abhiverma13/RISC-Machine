// Reading and Writing memory
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10

// Numbers for seven segment display
`define d_ZERO 7'b1000000
`define d_ONE 7'b1111001
`define d_TWO 7'b0100100
`define d_THREE 7'b0110000
`define d_FOUR 7'b0011001
`define d_FIVE 7'b0010010
`define d_SIX 7'b0000010
`define d_SEVEN 7'b1111000
`define d_EIGHT 7'b0000000
`define d_NINE 7'b0011000

// Letters
`define d_A 7'b0001000
`define d_b 7'b0000011
`define d_C 7'b1000110
`define d_d 7'b0100001
`define d_E 7'b0000110
`define d_F 7'b0001110

module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Wires for various connections
    wire [1:0] mem_cmd;
    wire [8:0] mem_addr;    // 9th bit checks if positive
    wire [15:0] read_data;
    wire [15:0] write_data;
    wire [15:0] dout;
    wire N, V, Z, w;
    wire mread, msel, mwrite, writeAnd;       // Two checks for reading memory
    wire enable;
    wire switchEnable;
    wire ledEnable;

    // Instantiate RAM and CPU modules
    // Write is always 0 for some reason in the handout
    RAM #(16, 8, "data.txt") MEM(.clk(~KEY[0]), .read_address(mem_addr[7:0]), .write_address(mem_addr[7:0]), .write(writeAnd), .din(write_data), .dout(dout));
    cpu CPU(.clk(~KEY[0]), .reset(~KEY[1]), .s(~KEY[2]), .load(~KEY[3]), .read_data(read_data) , .out(write_data), .N(N), .V(V), .Z(Z), .w(w), .mem_cmd(mem_cmd), .mem_addr(mem_addr));

    // Logic for mem read
    assign mread = (mem_cmd == `MREAD) ? 1'b1 : 1'b0;
    assign mwrite = (mem_cmd == `MWRITE) ? 1'b1 : 1'b0;
    assign writeAnd = mwrite & msel; // Checks if we should write to memory

    // Logic for positive PC
    assign msel = (mem_addr[8] == 1'b0) ? 1'b1 : 1'b0; // Checks if we have positive PC

    // AND to determine enable
    assign enable = mread & msel; // Checks if we should enable memory

    // Only take dout if switch enable is off and normal enable works
    // Other wise if switch enable off and normal enable off then all z
    // other wise if switch enable on then always take it
    getReadData GRD(.dout(dout), .switchData({8'b0, SW[7:0]}), .enable(enable), .switchEnable(switchEnable), .read_data(read_data));
    // assign read_data = enable ? dout : {16{1'bz}};

    // Instantiate switchLDR module
    switchLDR SWITCHLDR(.mem_cmd(mem_cmd), .mem_addr(mem_addr), .switchEnable(switchEnable));

    // Instantiate ledSTR module for led register enable
    ledSTR LEDSTR(.mem_cmd(mem_cmd), .mem_addr(mem_addr), .ledEnable(ledEnable));

    // load enable register for the leds
    registerLDE #(8) regLDELED(.in(write_data[7:0]), .load(ledEnable), .clk(~KEY[0]), .out(LEDR[7:0]));


    // Visualization
    assign HEX5[0] = ~Z;
    assign HEX5[6] = ~N;
    assign HEX5[3] = ~V;

    sseg H0(write_data[3:0],   HEX0);
    sseg H1(write_data[7:4],   HEX1);
    sseg H2(write_data[11:8],  HEX2);
    sseg H3(LEDR[3:0], HEX3);
    // sseg H3(write_data[15:12], HEX3);
    sseg H4(SW[3:0],    HEX4);

    assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
    assign LEDR[8] = 1'b1;
    assign LEDR[9] = 1'b1;
endmodule


module sseg(in,segs);

  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F

    input [3:0] in;
    output reg [6:0] segs;

    always @(*) begin
        case (in)
            4'b0000: segs = `d_ZERO; // 0
            4'b0001: segs = `d_ONE;  // 1
            4'b0010: segs = `d_TWO;  // 2
            4'b0011: segs = `d_THREE; // 3
            4'b0100: segs = `d_FOUR; // 4
            4'b0101: segs = `d_FIVE; // 5
            4'b0110: segs = `d_SIX; // 6
            4'b0111: segs = `d_SEVEN; // 7
            4'b1000: segs = `d_EIGHT; // 8
            4'b1001: segs = `d_NINE; // 9
            4'b1010: segs = `d_A; // A
            4'b1011: segs = `d_b; // b
            4'b1100: segs = `d_C; // C
            4'b1101: segs = `d_d; // d
            4'b1110: segs = `d_E; // E
            4'b1111: segs = `d_F; // F
        endcase
    end
endmodule
