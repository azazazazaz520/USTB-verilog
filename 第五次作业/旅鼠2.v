/*除了靠左和靠右走,如果地面消失了旅鼠会下落并大喊aaah!.

当地面消失时（ground=0）,旅鼠会下坠并说“aaah！”.当地面重新出现(ground=1)时,旅鼠将恢复为坠落前相同的方向行走.
下落过程中撞击无效,与地面消失同一周期被撞击(但尚未坠落)、或落地同一周期被撞击,不影响行走方向.
*/
module top_module(
    input clk,
    input areset,    // 异步复位，复位后默认向左走
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah 
);

//两种状态
//摩尔状态机
parameter LEFT = 2'b00;
parameter RIGHT = 2'b01;
parameter FALLing = 2'b10;
reg [1:0]state,next_state;
reg side;//记录下落前行走的方向，0为左，1为右
//三段式

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
        LEFT:begin    //在左边
            if(!ground) begin
                next_state = FALLing;
            end else if(bump_left) begin
                next_state = RIGHT;
                side = 1;
            end else begin
                next_state = LEFT;
                side = 0;
            end
            end
        RIGHT:begin   //在右边
            if(!ground) begin
                next_state = FALLing;
            end else if(bump_right) begin
                next_state = LEFT;
                side = 0;
            end else begin
                next_state = RIGHT;
                side = 1;
            end            
        end
        FALLing:begin
            if(ground) begin
                if(side) begin
                    next_state = RIGHT;
                end else begin
                    next_state = LEFT;
                end
            end else begin
                next_state = FALLing;//继续下落
            end            
        end
        default: next_state = LEFT;
    endcase
end

//输出逻辑
always@(*) begin
    case(state) 
        LEFT:begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            end
        RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        FALLing: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;  // 进入下落状态时，输出“aaah”信号
        end
        default: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end
    
endmodule
