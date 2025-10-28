module PalindromicSequenceDetector(
    input wire CLK,   // 时钟信号
    input wire In,    // 数据输入
    output wire OUT   // 输出回文检测结果
);
    // 使用一个5位宽的寄存器来存储输入数据，初始化为0
    reg [4:0] r = 0;  // 5位寄存器，存储当前输入及前4个数据
    reg [2:0] count = 0;  // 用于计数已输入的数据位数

    always @(posedge CLK) begin
        if (count < 5) begin
            // 只在寄存器未满时更新寄存器并计数
            r <= {r[3:0], In};  // 将寄存器r的前四位右移一位，并将当前输入In放入最低位
            count <= count + 1;  // 增加计数
        end else begin
            // 一旦寄存器已满，继续更新，但不再计数
            r <= {r[3:0], In};  // 将寄存器r的前四位右移一位，并将当前输入In放入最低位
        end
    end

    // 只有当输入满5位时，开始检测回文序列
    // 如果是回文序列输出高电平（1），否则输出低电平（0）
    assign OUT = (count >= 5) && (r[4] == r[0]) && (r[3] == r[1]);

endmodule
