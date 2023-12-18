module getReadData(dout, switchData, enable, switchEnable, read_data);
    input [15:0] dout;
    input [15:0] switchData;
    input enable;
    input switchEnable;
    output reg [15:0] read_data;

    // Only take dout if switch enable is off and normal enable works
    // Other wise if switch enable off and normal enable off then all z
    // other wise if switch enable on then always take it
    always @ (*) begin
        case(switchEnable)
            1'b0: begin
                if (enable) begin
                    read_data = dout;
                end else begin
                    read_data = 16'bz;
                end
            end
            default: read_data = switchData;
        endcase
    end
endmodule