module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out
);

// 状态定义
parameter A = 1'b0;
parameter B = 1'b1;

reg state;

// 状态寄存器（异步复位到状态B）
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;  // 异步复位到状态B
    end else begin
        state <= next_state;
    end
end

// 下一状态逻辑
reg next_state;
always @(*) begin
    case (state)
        A: next_state = in ? A : B;  // A状态：in=1保持A，in=0转到B
        B: next_state = in ? B : A;  // B状态：in=1保持B，in=0转到A
        default: next_state = B;     // 默认复位到B
    endcase
end

// 输出逻辑（摩尔型：输出只与当前状态有关）
assign out = (state == B);  // B状态输出1，A状态输出0

endmodule