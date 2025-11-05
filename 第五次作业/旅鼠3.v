/*除了行走和下落之外,有时还可以告诉旅鼠做一些有用的事情,比如挖洞(dig=1时开始挖洞).
如果一只旅鼠正在地面上行走(ground=1),它可以转换成挖掘状态直到到达端点(ground=0).
在那一点上,由于没有地面,它会掉下来(aaah!),然后当它再次落地后将继续沿着它原来的方向行走.
和坠落一样,在挖掘时被撞击没有效果,在坠落或没有地面时挖掘无效.

换言之,一个行尸走肉的旅鼠可能会跌落、dig或改变方向.
如果满足这些条件中的一个以上,则跌落的优先级高于dig,dig的优先级高于切换方向.

扩展之前的有限状态机来模拟这种行为.
*/
module top_module(
    input clk,
    input areset,    // 异步复位，复位后默认向左走
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging //挖
);

//四种状态
//摩尔状态机
parameter LEFT = 2'b00;
parameter RIGHT = 2'b01;
parameter FALLing = 2'b10;
parameter DIGGING = 2'b11;
reg [1:0]state,next_state;
reg side;//记录下落前或者挖之前行走的方向，0为左，1为右
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
            end else if(dig) begin
                next_state = DIGGING; //dig = 1时开始挖洞
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
            end else if(dig) begin
                next_state = DIGGING; //dig = 1时开始挖洞
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
        DIGGING：begin
            if (!ground) begin
                    next_state = FALLing;  // 地面消失，进入下落状态
                end else begin
                    next_state = DIGGING; // 继续挖掘
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
            digging = 0;
            end
        RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        FALLing: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;  // 进入下落状态时，输出“aaah”信号
            digging = 0;
        end
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        default: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
    endcase
end
    
endmodule
