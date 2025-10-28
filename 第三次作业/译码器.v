`timescale 1ns / 1ps
module id(
    input wire [15:0] fs_to_ds_bus,
    input wire [7:0] rx_value,
    input wire [7:0] ry_value,
    output wire [27:0] ds_to_es_bus,
    output wire [1:0] rx,
    output wire [1:0] ry
    );
    wire [7:0] pc_value;
    wire [3:0] op_code;
    wire [1:0] rx_addr;
    wire [1:0] ry_addr;
    wire [3:0] op_one_hot;
    
    assign pc_value = fs_to_ds_bus[15:8];
    assign op_code = fs_to_ds_bus[7:4];
    assign ry_addr = fs_to_ds_bus[3:2];
    assign rx_addr = fs_to_ds_bus[1:0];
    
    assign rx = rx_addr;
    assign ry = ry_addr;
    assign op_one_hot = (op_code == 4'b0001) ? 4'b1000 :     //move
                        (op_code == 4'b0010) ? 4'b0100 :     //add
                        (op_code == 4'b0011) ? 4'b0010 :     //sub
                        (op_code == 4'b0100) ? 4'b0001 :     //sub
                        4'b0000;
    assign ds_to_es_bus = {op_one_hot,   //[27:24]
                           ry_value,     //[23:16]
                           rx_value,     //{15:8]
                           pc_value};    //[7:0]
endmodule

