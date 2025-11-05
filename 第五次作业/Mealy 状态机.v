module mealy (
    input  wire clk,
    input  wire areset,  // 异步高电平复位
    input  wire in,
    output reg  out
);

    // 状态编码
    parameter A = 1'b0;
    parameter B = 1'b1;

    reg state, next_state;

    // 异步复位 + 状态寄存器
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // 状态转移逻辑
    always @(*) begin
        case (state)
            A: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            default: next_state = A;
        endcase
    end

    // 输出逻辑（Mealy 型：依赖输入）
    always @(*) begin
        case (state)
            A: out = in ? 1'b1 : 1'b0;
            B: out = in ? 1'b1 : 1'b0;
            default: out = 1'b0;
        endcase
    end

endmodule
