module pipeline_adder (
    input wire clk,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire cin,
    output reg [31:0] sum,
    output reg cout
);

    reg [15:0] a_low_reg1, b_low_reg1;
    reg [15:0] a_high_reg1, b_high_reg1;
    reg cin_reg1;

    reg [15:0] sum_low_reg2;
    reg carry_low_reg2;
    reg [15:0] a_high_reg2, b_high_reg2;

    reg [15:0] sum_high_reg3;
    reg [15:0] sum_low_reg3;
    reg carry_high_reg3;

    reg [31:0] sum_reg4;
    reg cout_reg4;

    always @(posedge clk) begin
        a_low_reg1 <= a[15:0];
        b_low_reg1 <= b[15:0];
        a_high_reg1 <= a[31:16];
        b_high_reg1 <= b[31:16];
        cin_reg1 <= cin;
    end

    always @(posedge clk) begin
        {carry_low_reg2, sum_low_reg2} <= a_low_reg1 + b_low_reg1 + cin_reg1;
        a_high_reg2 <= a_high_reg1;
        b_high_reg2 <= b_high_reg1;
    end

    always @(posedge clk) begin
        {carry_high_reg3, sum_high_reg3} <= a_high_reg2 + b_high_reg2 + carry_low_reg2;
        sum_low_reg3 <= sum_low_reg2;
    end

    always @(posedge clk) begin
        sum <= {sum_high_reg3, sum_low_reg3};
        cout <= carry_high_reg3;
    end

endmodule