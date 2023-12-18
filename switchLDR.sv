// Lab 7 memory constants
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10

module switchLDR(mem_cmd,mem_addr,switchEnable);
    input [1:0] mem_cmd;
    input [8:0] mem_addr;
    output reg switchEnable;

    // Combinational logic for switchEnable
    always @(*) begin
        case (mem_addr)
            9'h140: begin
                if (mem_cmd == `MREAD) begin
                    switchEnable = 1'b1;
                end else begin
                    switchEnable = 1'b0;
                end
            end
            default: begin
                switchEnable = 1'b0;
            end
        endcase
    end
endmodule