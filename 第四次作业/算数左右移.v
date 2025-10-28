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
            // 加载数据到寄存器
            q <= data;
        end else if (ena) begin
            // 根据amount选择移位操作
            case (amount)
                2'b00: begin
                    // 算术左移1位
                    q <= q << 1;
                end
                2'b01: begin
                    // 算术左移8位
                    q <= q << 8;
                end
                2'b10: begin
                    // 算术右移1位
                    if (q[63] == 1) begin
                        // 符号位为1，进行算术右移
                        // 最高位复制一次，然后高位右移填充：{q[63], q[63:1]} 正好是 64 位
                        q <= {q[63], q[63:1]};
                    end else begin
                        // 符号位为0，进行逻辑右移
                        q <= q >> 1;
                    end
                end
                2'b11: begin
                    // 算术右移8位
                    if (q[63] == 1) begin
                        // 符号位为1，进行算术右移8位：高8位都填充符号位
                        q <= {{8{q[63]}}, q[63:8]};
                    end else begin
                        // 符号位为0，进行逻辑右移8位
                        q <= q >> 8;
                    end
                end
                default: begin
                    // 默认情况：不做任何操作
                    q <= q;
                end
            endcase
        end
    end

endmodule
