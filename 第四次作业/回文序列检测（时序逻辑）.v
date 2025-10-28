module PalindromicSequenceDetector(
    input wire CLK,   
    input wire IN,    
    output wire OUT   
);
    
    reg [4:0] r = 0;  
    reg [2:0] count = 0;  
    always @(posedge CLK) begin
        if (count < 5) begin
            r <= {r[3:0], IN};  
            count <= count + 1;  
        end else begin
            r <= {r[3:0], IN};  
        end
    end
    assign OUT = (count >= 5) && (r[4] == r[0]) && (r[3] == r[1]);

endmodule
