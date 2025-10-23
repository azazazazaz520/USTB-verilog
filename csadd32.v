`timescale 1ns / 1ps
module csadd32(
     input  wire [31:0] a,
     input  wire [31:0] b,
     input  wire cin,
     output wire [31:0] s,
     output wire cout
    );
    wire [7:0]carry;
    carry_adder_4bit Block0(
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(s[3:0]),
        .cout(carry[0])        
    );
    carry_adder_4bit Block1(
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry[0]),
        .sum(s[7:4]),
        .cout(carry[1])
    );
    carry_adder_4bit Block2(
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(carry[1]),
        .sum(s[11:8]),
        .cout(carry[2])
    );
    carry_adder_4bit Block3(
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(carry[2]),
        .sum(s[15:12]),
        .cout(carry[3])
    );
    carry_adder_4bit Block4(
        .a(a[19:16]),
        .b(b[19:16]),
        .cin(carry[3]),
        .sum(s[19:16]),
        .cout(carry[4])
    );
    carry_adder_4bit Block5(
        .a(a[23:20]),
        .b(b[23:20]),
        .cin(carry[4]),
        .sum(s[23:20]),
        .cout(carry[5])
    );
    carry_adder_4bit Block6(
        .a(a[27:24]),
        .b(b[27:24]),
        .cin(carry[5]),
        .sum(s[27:24]),
        .cout(carry[6])
    );
    carry_adder_4bit Block7(
        .a(a[31:28]),
        .b(b[31:28]),
        .cin(carry[6]),
        .sum(s[31:28]),
        .cout(carry[7])
    );
    assign cout = carry[7];
endmodule


module HalfAdder (
    input wire A,
    input wire B,
    output wire Sum,
    output wire Carry
);
    assign Sum = A^B;
    assign Carry = A & B;
endmodule
module FullAdder (
    input wire A,
    input wire B,
    input wire Cin ,
    output wire Sum,
    output wire Cout
   );
   wire sum_ha1 , carry_ha1 , carry_ha2 ;
    HalfAdder HA1(
        .A (A ) ,
        .B (B ) ,
        .Sum (sum_ha1 ) ,
        .Carry ( carry_ha1 )
);
    HalfAdder HA2(
        .A (sum_ha1 ) ,
        .B ( Cin ) ,
        .Sum (Sum ) ,
        . Carry ( carry_ha2 )
       );
       assign Cout = carry_ha1 | carry_ha2;
endmodule
module carry_adder_4bit(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] carry;
    FullAdder FA1(.A(a[0]),.B(b[0]),.Cin(cin),.Sum(sum[0]), .Cout(carry[0]));
    FullAdder FA2(.A(a[1]),.B(b[1]),.Cin(carry[0]),.Sum(sum[1]), .Cout(carry[1]));
    FullAdder FA3(.A(a[2]),.B(b[2]),.Cin(carry[1]),.Sum(sum[2]), .Cout(carry[2]));
    FullAdder FA4(.A(a[3]),.B(b[3]),.Cin(carry[2]),.Sum(sum[3]), .Cout(carry[3]));
    
    
    assign cout = carry[3];
endmodule



