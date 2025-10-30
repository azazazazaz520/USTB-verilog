`timescale 1ns / 1ps
module lock(
    input clk,
    input rst,
    input in,
    output reg unlock
);
parameter [15:0] stu_pwd = 16'b0001 0001 0111 1011;//4475

localparam IDLE =2'b00;
localparam INPUT =2'b01;//输入状态
localparam CHECK =2'b10;//校验状态
reg [3:0] temp; //临时存储输入的1位密码
reg [15:0] input_pwd; //存储输入的密码
reg [2:0] cnt;
reg alock;
reg [1:0] state; //状态机
reg input_done;//输入完成标志
always @(posedge clk or posedge rst) begin
    if(rst) begin
        temp = arst;
        input_pwd = arst;
        state = IDLE;
    end
end
endmodule