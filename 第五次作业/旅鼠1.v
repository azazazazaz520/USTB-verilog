
/*旅鼠是一种头脑简单的动物，非常简单,这里将用一个有限状态机对它进行建模.

在旅鼠的二维世界中,旅鼠可以处于两种状态之一：靠左行走或靠右行走.如果碰到障碍物,它会改变方向.
比如：如果一只旅鼠在左边撞了墙,它就会靠右走.如果它撞到右边的石头,它就会靠左走.如果它在两侧同时发生碰撞,它仍然会改变当前方向.

实现一个摩尔状态机来模拟旅鼠的行为：异步复位（高电平有效）到靠左走，左右是否发生碰撞为状态机的输入（bump_left,bump_right)，
靠左走或靠右走为状态机的输出(walk_left,walk_right).*/

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);
//两种状态
//摩尔状态机
parameter LEFT = 1'b0;
parameter RIGHT = 1'b1;

reg state,next_state;


always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= LEFT;
    end
    else begin
        state <= next_state;
    end
end

always@(*) begin
    case(state)
        LEFT:begin
            if(bump_left) begin
                next_state = RIGHT;
                end 
                else begin 
                    next_state = LEFT;
                end
            end
        RIGHT:begin
            if(bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
    endcase
end
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
endmodule