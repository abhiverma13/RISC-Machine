module regfile(data_in, writenum, write, readnum, clk, data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;

    // Set 8 registers
    reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7; 

    // One hot select lines for write and read
    wire [7:0] write_select, read_select; 

    // 3:8 decoders for writenum and readnum
    assign write_select = 1 << writenum;
    assign read_select = 1 << readnum;

    // Only write when clock is high
    always @(posedge clk) begin
        if (write) begin
            case (write_select)
                8'b00000001: R0 <= data_in;
                8'b00000010: R1 <= data_in;
                8'b00000100: R2 <= data_in;
                8'b00001000: R3 <= data_in;
                8'b00010000: R4 <= data_in;
                8'b00100000: R5 <= data_in;
                8'b01000000: R6 <= data_in;
                8'b10000000: R7 <= data_in;
                default: R0 <= 16'bx;
            endcase
        end else begin
            R0 <= R0;
            R1 <= R1;
            R2 <= R2;
            R3 <= R3;
            R4 <= R4;
            R5 <= R5;
            R6 <= R6;
            R7 <= R7;
        end
    end

    // Read logic using a multiplexer 
    assign data_out = (read_select[0] ? R0 :
                       read_select[1] ? R1 :
                       read_select[2] ? R2 :
                       read_select[3] ? R3 :
                       read_select[4] ? R4 :
                       read_select[5] ? R5 :
                       read_select[6] ? R6 : R7);

endmodule
