// Lab 7 memory constants
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10

module ledSTR(mem_cmd, mem_addr, ledEnable);
    input [1:0] mem_cmd;
    input [8:0] mem_addr;
    output reg ledEnable;

    // Combinational logic for ledEnable
    always @(*) begin
        case (mem_addr)
            9'h100: begin
                if (mem_cmd == `MWRITE) begin
                    ledEnable = 1'b1;
                end else begin
                    ledEnable = 1'b0;
                end
            end
            default: begin
                ledEnable = 1'b0;
            end
        endcase
    end
endmodule