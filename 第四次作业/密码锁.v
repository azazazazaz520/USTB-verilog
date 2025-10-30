`timescale 1ns / 1ps
module lock(
    input clk,
    input rst,
    input in,
    output reg unlock
);
parameter [3:0] arst = 4'b0000,stu_pwd = ;
reg [3:0] temp; //临时存储输入的4位密码
reg [3:0] input_pwd; //存储输入的密码
reg [2:0] cnt;
reg alock;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        temp = arst;
        input_pwd = arst;
    end
    else if(in >= 0 && in < 10 && cnt < 4) begin
        case(in)
            4'b0000: begin
                temp = {temp[2:0],0};
                cnt = cnt + 1;
            end
            4'b0001: begin
                temp = {temp[2:0],1};
                cnt = cnt + 1;
            end
            4'b0010: begin
                temp = {temp[2:0],2};
                cnt = cnt + 1;
            end
            4'b0011: begin
                temp = {temp[2:0],3};
                cnt = cnt + 1;
            end
            4'b0100: begin
                temp = {temp[2:0],4};
                cnt = cnt + 1;
            end
            4'b0101: begin
                temp = {temp[2:0],5};
                cnt = cnt + 1;
            end
            4'b0110: begin
                temp = {temp[2:0],6};
                cnt = cnt + 1;
            end
            4'b0111: begin
                temp = {temp[2:0],7};
                cnt = cnt + 1;
            end
            4'b1000: begin
                temp = {temp[2:0],8};
                cnt = cnt + 1;
            end
            4'b1001: begin
                temp = {temp[2:0],9};
                cnt = cnt + 1;
            end
        endcase       
    end
    else if(cnt == 4 || in >= 10) begin
        input_pwd = temp;
        if(input_pwd == stu_pwd) begin
            alock <= 1'b1; 
        end
        else begin
            alock <= 1'b0;
        end
    end
end
assign unlock = alock;
endmodule