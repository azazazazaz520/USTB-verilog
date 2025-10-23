module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);
assign w = {a,b[4:2]};          
    assign x = {b[2:0], c, d[4]};    
    assign y = {d[3:0], e[4:1]};     
    assign z = {e[1:0], f, 2'b11};
endmodule