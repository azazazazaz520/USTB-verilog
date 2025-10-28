`timescale 1ns / 1ps
module rcadd32(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire cin,
    output wire [31:0] s,
    output wire cout
    );
    reg [32:0] carry;
    reg [31:0]sum;
    integer i;
    always @(*) begin
        carry[0] = cin;
        for (i = 0; i < 32; i = i + 1) begin
            sum[i] = a[i] ^ b[i] ^ carry[i];
            carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    end
    assign cout = carry[32];
    assign s = sum;
endmodule
