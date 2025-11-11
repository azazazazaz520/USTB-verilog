/*虽然旅鼠可以走路，坠落和挖掘，但旅鼠并不是无懈可击的。
如果一个旅鼠下降太久（大于等于20个时钟周期）然后击中地面，它会飞溅，并永远停止行走、下降或挖掘（即所有4个输出变为0）直到状态机被复位。
（注意旅鼠只会在击中地面时飞溅，不会在半空中飞溅）

扩展前面的有限状态机以模拟此行为

下降正好20个周期落地时，是可以存活的
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
parameter LEFT = 3'b000;
parameter RIGHT = 2'b001;
parameter FALLing = 2'b010;
parameter DIGGING = 2'b011;
parameter DIE = 3'b100;      //爱鼠TV
reg [2:0]state,next_state;
reg side;//记录下落前或者挖之前行走的方向，0为左，1为右
reg [4:0] cnt;//如果坠落，用这个寄存器开始计数
//三段式

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= LEFT;
        cnt <= 0;
    end
    else begin
        state <= next_state;
        if(state == FALLing) begin
            cnt = cnt + 1;
        end else begin
            cnt <= 0;
        end
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
                if(cnt > 19) begin
                next_state = DIE;
                end else if(side) begin
                    next_state = RIGHT;
                end else begin
                    next_state = LEFT;
                end
            end else begin
                next_state = FALLing;//继续下落
            end            
        end
        DIGGING:begin
            if (!ground) begin
                    next_state = FALLing;  // 地面消失，进入下落状态
                end else begin
                    next_state = DIGGING; // 继续挖掘
                end
        end
        DIE:begin
            next_state = DIE;          // 保持死亡状态
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
            digging = 1;
        end
        DIE: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        default: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end
    
endmodule