module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        case (amount)
            2'b00 : q <= q << 1;         // 左移1位
            2'b01 : q <= q << 8;         // 左移8位
            2'b10: begin
                    // 算术右移1位
                    if (q[63] == 1) begin
                        // 符号位为1，进行算术右移
                        q <= {q[63], q[63:1]};
                    end else begin
                        // 符号位为0，进行逻辑右移
                        q <= q >> 1;
                    end
                end
                2'b11: begin
                    // 算术右移8位
                    if (q[63] == 1) begin
                        // 符号位为1，进行算术右移
                        q <= {q[63], q[63:8]};
                    end else begin
                        // 符号位为0，进行逻辑右移
                        q <= q >> 8;
                    end
                end
            default: begin 
                q <= q;
            end
        endcase
    end
end
endmodule