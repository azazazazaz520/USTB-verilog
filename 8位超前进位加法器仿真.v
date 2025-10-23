module tb_adder_top;
    reg [7:0] a, b;
    reg cin;
    wire [7:0] s;
    wire cout;
    
    // 实例化被测模块
    adder_top dut(
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );
    
    initial begin
        // 初始化
        a = 8'b0;
        b = 8'b0;
        cin = 0;
        
        // 测试用例1: 简单加法
        #10 a = 8'd10; b = 8'd20; cin = 0;
        #10 $display("Test 1: %d + %d + %d = %d, Cout = %b", a, b, cin, s, cout);
        
        // 测试用例2: 带进位输入
        #10 a = 8'd100; b = 8'd100; cin = 1;
        #10 $display("Test 2: %d + %d + %d = %d, Cout = %b", a, b, cin, s, cout);
        
        // 测试用例3: 边界情况 - 最大值
        #10 a = 8'd255; b = 8'd1; cin = 0;
        #10 $display("Test 3: %d + %d + %d = %d, Cout = %b", a, b, cin, s, cout);
        
        // 测试用例4: 产生进位链
        #10 a = 8'b10101010; b = 8'b01010101; cin = 0;
        #10 $display("Test 4: %b + %b + %d = %b, Cout = %b", a, b, cin, s, cout);
        
        // 测试用例5: 随机测试
        #10 a = $random; b = $random; cin = $random & 1;
        #10 $display("Test 5: %d + %d + %d = %d, Cout = %b", a, b, cin, s, cout);
        
        #10 $finish;
    end
    
    initial begin
        $dumpfile("adder_wave.vcd");
        $dumpvars(0, tb_adder_top);
    end
endmodule