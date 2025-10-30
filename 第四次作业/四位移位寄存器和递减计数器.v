module top_module (
    input clk,
    input reset,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);
reg [3:0] output_q;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        output_q <= 4'b0000;
    end
    else if(shift_ena) begin
        output_q <= {output_q[2:0],data};
    end
    else if(count_ena) begin
        output_q <= output_q - 1;
    end

end
assign q = output_q;
endmodule