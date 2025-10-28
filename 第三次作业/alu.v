`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/23 18:06:23
// Design Name: 
// Module Name: ALU
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


module ALU (    
    input wire [7:0] alu_src1,
    input wire [7:0] alu_src2,    
    input wire [11:0] alu_op,    
    output wire [7:0] alu_result  
);
    function [7:0]nperm_operation;
        input [7:0] oprand1;
        input [7:0] oprand2;
        reg [3:0] high_nibble;
        reg [3:0] low_nibble;
        begin
            // 高半字节
            case (oprand2[3:2])
                2'b00: high_nibble = oprand1[7:4];
                2'b01: high_nibble = oprand1[3:0];
                2'b10: high_nibble = oprand2[7:4];
                2'b11: high_nibble = oprand2[3:0];
                default: high_nibble = 4'b0000;
            endcase
            
            // 低半字节
            case (oprand2[1:0])
                2'b00: low_nibble = oprand1[7:4];
                2'b01: low_nibble = oprand1[3:0];
                2'b10: low_nibble = oprand2[7:4];
                2'b11: low_nibble = oprand2[3:0];
                default: low_nibble = 4'b0000;
            endcase
            
            // 返回拼接结果
            nperm_operation = {high_nibble, low_nibble};
        end
     endfunction
    function [7:0]carry_add_result;
        input [7:0]rx_value;
        input [7:0]ry_value;
        reg [8:0] carry_add_temp;
        begin
            carry_add_temp = {1'b0, rx_value} + {1'b0, ry_value};
            carry_add_result = carry_add_temp[7:0];
        end
    endfunction    
    function [7:0]carry;
        input [7:0]rx_value;
        input [7:0]ry_value;
        reg t;
        reg [7:0]result;
        begin
            {t,result} = rx_value + ry_value;
            if (t == 1)
                carry = {t,result[7:1]};
            else
                carry = result;
        end
    endfunction
    wire [7:0] rx_value;
    wire [7:0] ry_value;
    wire [11:0] op_code;
    wire [1:0] b;
    assign op_code = alu_op;
    assign rx_value = alu_src1;
    assign ry_value = alu_src2;
    assign b = alu_src2[1:0];

    assign alu_result = (op_code == 12'h001) ? (rx_value+ry_value):
                        (op_code == 12'h002) ? (rx_value-ry_value):
                        (op_code == 12'h004) ? (rx_value&ry_value):
                        (op_code == 12'h008) ? (rx_value||ry_value):
                        (op_code == 12'h010) ? (rx_value << b):
                        (op_code == 12'h020) ? (rx_value >>> b):
                        (op_code == 12'h040) ? ((rx_value >> b) | (ry_value >> 8-b)):
                        (op_code == 12'h080) ? (($signed(rx_value) < $signed(ry_value)) ? 1:0):
                        (op_code == 12'h100) ? ((rx_value < ry_value) ? 1:0):
                        (op_code == 12'h200) ? (carry(rx_value,ry_value)):
                        (op_code == 12'h400) ? (rx_value ^ ry_value):
                        (op_code == 12'h800) ? (nperm_operation(rx_value,ry_value)):
                        8'b0000000;
                         
endmodule
