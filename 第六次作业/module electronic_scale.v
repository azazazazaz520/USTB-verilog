module electronic_scale(
    input clk,                    // 系统时钟
    input rst,                    // 系统复位
    input [15:0] weight,         // 重量输入（16位）
    input [15:0] price,          // 单价输入（16位）
    input accumulate_btn,        // 累计按键
    input clear_accumulate_btn,  // 清除累计按键
    input clear_btn,             // 清零按键
    output reg [6:0] segment,    // 7段数码管段选信号
    output reg [3:0] digit_sel   // 数码管位选信号
);

// 状态定义
localparam STATE_NORMAL = 2'b00;    // 普通状态
localparam STATE_ACCUMULATE = 2'b01; // 累计状态
localparam STATE_CLEAR = 2'b10;     // 清零状态

// 寄存器定义
reg [1:0] current_state;           // 当前状态
reg [1:0] next_state;              // 下一状态
reg [31:0] current_total;          // 当前物品总价
reg [31:0] accumulated_total;      // 累计总价
reg [7:0] item_count;              // 物品计数
reg [31:0] display_value;          // 显示数值
reg [1:0] display_mode;            // 显示模式

// 数码管显示编码（共阴极）
parameter SEG_0 = 7'b1000000;  // 0
parameter SEG_1 = 7'b1111001;  // 1
parameter SEG_2 = 7'b0100100;  // 2
parameter SEG_3 = 7'b0110000;  // 3
parameter SEG_4 = 7'b0011001;  // 4
parameter SEG_5 = 7'b0010010;  // 5
parameter SEG_6 = 7'b0000010;  // 6
parameter SEG_7 = 7'b1111000;  // 7
parameter SEG_8 = 7'b0000000;  // 8
parameter SEG_9 = 7'b0010000;  // 9
parameter SEG_A = 7'b0001000;  // A
parameter SEG_C = 7'b1000110;  // C
parameter SEG_L = 7'b1000111;  // L
parameter SEG_R = 7'b0101111;  // R
parameter SEG_NONE = 7'b1111111; // 不显示

// 状态寄存器更新
always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= STATE_NORMAL;
    end else begin
        current_state <= next_state;
    end
end

// 状态转移逻辑
always @(*) begin
    case (current_state)
        STATE_NORMAL: begin
            if (clear_btn) begin
                next_state = STATE_CLEAR;
            end else if (accumulate_btn) begin
                next_state = STATE_ACCUMULATE;
            end else begin
                next_state = STATE_NORMAL;
            end
        end
        
        STATE_ACCUMULATE: begin
            if (clear_accumulate_btn) begin
                next_state = STATE_NORMAL;
            end else if (clear_btn) begin
                next_state = STATE_CLEAR;
            end else begin
                next_state = STATE_ACCUMULATE;
            end
        end
        
        STATE_CLEAR: begin
            // 清零状态持续一段时间后返回普通状态
            next_state = STATE_NORMAL;
        end
        
        default: next_state = STATE_NORMAL;
    endcase
end

// 计算当前物品总价（重量 × 单价）
always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_total <= 32'd0;
    end else begin
        current_total <= weight * price;
    end
end

// 累计逻辑
always @(posedge clk or posedge rst) begin
    if (rst) begin
        accumulated_total <= 32'd0;
        item_count <= 8'd0;
    end else begin
        case (current_state)
            STATE_NORMAL: begin
                if (accumulate_btn) begin
                    // 按下累计键，将当前总价加入累计
                    accumulated_total <= accumulated_total + current_total;
                    item_count <= item_count + 1;
                end
            end
            
            STATE_ACCUMULATE: begin
                if (clear_accumulate_btn) begin
                    // 清除累计
                    accumulated_total <= 32'd0;
                    item_count <= 8'd0;
                end
            end
            
            STATE_CLEAR: begin
                // 清零所有数据
                accumulated_total <= 32'd0;
                item_count <= 8'd0;
            end
        endcase
    end
end

// 显示逻辑
always @(posedge clk or posedge rst) begin
    if (rst) begin
        display_value <= 32'd0;
        display_mode <= 2'b00;
    end else begin
        case (current_state)
            STATE_NORMAL: begin
                display_value <= current_total;
                display_mode <= 2'b00;  // 显示当前总价
            end
            
            STATE_ACCUMULATE: begin
                display_value <= accumulated_total;
                display_mode <= 2'b01;  // 显示累计信息
            end
            
            STATE_CLEAR: begin
                display_value <= 32'd0;
                display_mode <= 2'b10;  // 显示清零信息
            end
            
            default: begin
                display_value <= current_total;
                display_mode <= 2'b00;
            end
        endcase
    end
end

// 数码管扫描显示
reg [3:0] digit_value;
reg [15:0] scan_counter;
reg [1:0] digit_pos;

// 数码管扫描计数器
always @(posedge clk or posedge rst) begin
    if (rst) begin
        scan_counter <= 16'd0;
        digit_pos <= 2'd0;
    end else begin
        scan_counter <= scan_counter + 1;
        if (scan_counter == 16'd10000) begin  // 控制扫描频率
            scan_counter <= 16'd0;
            digit_pos <= digit_pos + 1;
            if (digit_pos == 2'd3) digit_pos <= 2'd0;
        end
    end
end

// 数码管位选和段选
always @(*) begin
    case (digit_pos)
        2'd0: digit_sel = 4'b1110;  // 最低位
        2'd1: digit_sel = 4'b1101;
        2'd2: digit_sel = 4'b1011;
        2'd3: digit_sel = 4'b0111;  // 最高位
        default: digit_sel = 4'b1111;
    endcase
    
    // 根据显示模式和数码管位置确定显示内容
    case (display_mode)
        2'b00: begin // 显示当前总价
            case (digit_pos)
                2'd0: digit_value = display_value[3:0];
                2'd1: digit_value = display_value[7:4];
                2'd2: digit_value = display_value[11:8];
                2'd3: digit_value = display_value[15:12];
            endcase
        end
        
        2'b01: begin // 显示累计信息
            case (digit_pos)
                2'd0: digit_value = accumulated_total[3:0];
                2'd1: digit_value = accumulated_total[7:4];
                2'd2: digit_value = item_count[3:0];  // 显示物品计数
                2'd3: digit_value = 4'hA;  // 显示'A'表示累计模式
            endcase
        end
        
        2'b10: begin // 显示清零信息
            case (digit_pos)
                2'd0: digit_value = 4'hC;  // C
                2'd1: digit_value = 4'hL;  // L
                2'd2: digit_value = 4'hR;  // R
                2'd3: digit_value = 4'h0;  // 空格
            endcase
        end
        
        default: digit_value = 4'h0;
    endcase
    
    // 7段数码管译码
    case (digit_value)
        4'h0: segment = SEG_0;
        4'h1: segment = SEG_1;
        4'h2: segment = SEG_2;
        4'h3: segment = SEG_3;
        4'h4: segment = SEG_4;
        4'h5: segment = SEG_5;
        4'h6: segment = SEG_6;
        4'h7: segment = SEG_7;
        4'h8: segment = SEG_8;
        4'h9: segment = SEG_9;
        4'hA: segment = SEG_A;  // 显示"A"表示累计
        4'hC: segment = SEG_C;  // 显示"C"
        4'hL: segment = SEG_L;  // 显示"L"
        4'hR: segment = SEG_R;  // 显示"R"
        default: segment = SEG_NONE;
    endcase
end

endmodule