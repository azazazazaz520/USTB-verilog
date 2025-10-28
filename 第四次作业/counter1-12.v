module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q
);
    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0001;
        end else if (enable) begin
            if (counter == 4'b1100) begin
                counter <= 4'b0001;
            end else begin
                counter <= counter + 1;
            end
        end
    end
    assign Q = counter;
endmodule