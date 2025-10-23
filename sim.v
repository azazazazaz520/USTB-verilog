`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/23 16:41:25
// Design Name: 
// Module Name: sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim();
    // 测试信号
    reg [15:0] fs_to_ds_bus;
    reg [7:0] rx_value, ry_value;
    wire [27:0] ds_to_es_bus;
    wire [1:0] rx, ry;
    
    id u_id(
    .fs_to_ds_bus(fs_to_ds_bus),
    .ds_to_es_bus(ds_to_es_bus),
    .rx(rx),
    .ry(ry),
    .rx_value(rx_value),
    .ry_value(ry_value)
    );
    initial begin
        fs_to_ds_bus = 16'h0;
        rx_value = 16'hAA;   //rx寄存器的值为10101010
        ry_value = 16'h55;   //ry寄存器的值为01010101
        #10;
    
        // 测试 move 指令 (操作码 0001)
        fs_to_ds_bus = {8'h12, 4'b0001, 2'b01, 2'b10};
        #10;
        $display("Move指令: ds_to_es_bus = %h", ds_to_es_bus);
        $display("rx = %b, ry = %b", rx, ry);
        
        // 测试 add 指令 (操作码 0010)
        fs_to_ds_bus = {8'h34, 4'b0010, 2'b00, 2'b11};
        #10;
        $display("Add指令: ds_to_es_bus = %h", ds_to_es_bus);
        
        // 测试 sub 指令 (操作码 0011)
        fs_to_ds_bus = {8'h56, 4'b0011, 2'b10, 2'b01};
        #10;
        $display("Sub指令: ds_to_es_bus = %h", ds_to_es_bus);
        
        // 测试 mul 指令 (操作码 0100)
        fs_to_ds_bus = {8'h78, 4'b0100, 2'b11, 2'b00};
        #10;
        $display("Mul指令: ds_to_es_bus = %h", ds_to_es_bus);
        
        // 测试非法操作码
        fs_to_ds_bus = {8'h9A, 4'b1111, 2'b01, 2'b10};
        #10;
        $display("非法操作码: ds_to_es_bus = %h", ds_to_es_bus);
        
        $finish;
    end

endmodule
