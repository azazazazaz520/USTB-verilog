module PalindromicSequenceDetector(
    input wire CLK,   
    input wire IN,    
    output wire OUT   
);
    
    reg [4:0] r = 0;  
    reg [2:0] count = 0;  
    always @(posedge CLK) begin
    r <= {r[3:0], IN};
    end
    assign OUT =  (r[3] == IN) && (r[2] == r[0]);

endmodule
