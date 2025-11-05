module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out
);
// 状态定义
parameter A = 1'b0;
parameter B = 1'b1;

reg current_state;  // 当前状态
reg next_state;  // 下一状态
reg a;
// 状态寄存器（异步复位）
always @(posedge clk or negedge areset) begin
    if (!areset) begin
        current_state <= B;  // 复位到状态B
    end else begin
        current_state <= next_state;
    end
end

// 下一状态逻辑
always @(*) begin
    case (current_state)
        A: next_state = in ? A : B;  // A状态：in=1保持A，in=0转到B
        B: next_state = in ? B : A;  // B状态：in=1保持B，in=0转到A
        default: next_state = A;
    endcase
end

// 输出逻辑（摩尔型：输出只与当前状态有关）
always @(*) begin
    case (current_state)
        A: a = 1'b0;  // A状态输出0
        B: a = 1'b1;  // B状态输出1
        default: a = 1'b0;
    endcase
end
assign out = a;
endmodule