module pipeline2 (
    input wire clk,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire cin,
    output reg [31:0] sum,
    output reg cout
);

    reg [31:0] a_reg, b_reg;
    reg cin_reg;
    reg [31:0] sum_reg;
    reg cout_reg;

    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        cin_reg <= cin;
        {cout_reg, sum_reg} <= a + b + cin; 
    end

    always @(posedge clk) begin
        sum <= sum_reg;
        cout <= cout_reg;
    end

endmodule