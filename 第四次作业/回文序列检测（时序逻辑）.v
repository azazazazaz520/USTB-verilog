module PalindromicSequenceDetector(
    input wire CLK,
    input wire IN,
    output wire OUT
);
    reg [4:0] r = 0;
    always @(posedge CLK) begin
        r <= {r[3:0], IN};
    end
    assign OUT = (r[4] == r[0]) && (r[3] == r[1]) && (r[2] == r[2]);
endmodule