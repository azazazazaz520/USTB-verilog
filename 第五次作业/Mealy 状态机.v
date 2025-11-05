module mealy (
    input  wire clk,
    input  wire areset,  // 异步高电平复位
    input  wire in,
    output reg  out
);

    // 状态定义
    parameter A = 1'b0;
    parameter B = 1'b1;

    reg state, next_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

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

   
    always @(*) begin
        out = (state == B) ? 1'b1 : 1'b0;
        if (!in)
            out = 1'b0;
    end

endmodule
