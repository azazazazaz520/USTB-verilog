module top_module (
    input clk,      // 时钟输入
    input reset,    // 同步复位信号，高电平有效
    output [3:0] q  // 计数器输出
);

    // 定义一个4位寄存器来存储计数器的当前值
    reg [3:0] counter;

    // 同步复位与计数器自增
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0001;  // 复位时，将计数器重置为1
        end else begin
            if (counter == 4'b1001) begin
                counter <= 4'b0000;  // 达到9后回到0
            end else begin
                counter <= counter + 1;  // 否则自增
            end
        end
    end

    // 将计数器值赋给输出q
    assign q = counter;

endmodule
