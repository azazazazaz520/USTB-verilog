`timescale 1ns / 1ps
module proc_fsm (
    input wire clk,
    input wire rst, 
    input wire w,
    input wire [1:0] F,
    input wire [1:0] Rx,
    input wire [1:0] Ry,

    output wire Done,
    output wire [3:0] Rin,//R0,...,R3寄存器的输入是否有效
    output wire [3:0] Rout,//R0,...,R3寄存器的输出是否有效
    output wire Ain,
    output wire Gin,
    output wire Gout,
    output wire addsub,
    output wire externx
);

    reg [3:0] Rin_internal;
    reg [3:0] Rout_internal;
    reg Ain_internal;
    reg Gin_internal;
    reg Gout_internal;
    reg addsub_internal;
    reg externx_internal;
    reg done_internal;

    reg [1:0] Rx_internal;
    reg [1:0] Ry_internal;
    reg [1:0] F_internal;

    localparam IDLE = 2'b00,
               LOAD_B = 2'b10,
               OUTPUT_G = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (w) begin
                    if (F == 2'b10 || F == 2'b11) begin
                        next_state = LOAD_B;
                    end else begin
                        next_state = IDLE;
                    end
                end else begin
                    next_state = IDLE;
                end
            end

            LOAD_B: next_state = OUTPUT_G;
            OUTPUT_G: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Rin_internal <= 4'b0000;
            Rout_internal <= 4'b0000;
            Ain_internal <= 1'b0;
            Gin_internal <= 1'b0;
            Gout_internal <= 1'b0;
            addsub_internal <= 1'b0;
            externx_internal <= 1'b0;
            done_internal <= 1'b0;
            Rx_internal <= 2'b00;
            Ry_internal <= 2'b00;
            F_internal <= 2'b00;
        end else begin
            if (w) begin
                Rx_internal <= Rx;
                Ry_internal <= Ry;
                F_internal <= F;
            end

            case (state)
                IDLE: begin
                    if (w) begin
                        case (F)
                            2'b00: begin
                                Rin_internal <= 4'b0001 << Rx;
                                Rout_internal <= 4'b0000;
                                Ain_internal <= 1'b0;
                                Gin_internal <= 1'b0;
                                Gout_internal <= 1'b0;
                                externx_internal <= 1'b1;
                                done_internal <= 1'b1;
                            end

                            2'b01: begin
                                Rin_internal <= 4'b0001 << Rx;
                                Rout_internal <= 4'b0001 << Ry;
                                Ain_internal <= 1'b0;
                                Gin_internal <= 1'b0;
                                Gout_internal <= 1'b0;
                                externx_internal <= 1'b0;
                                done_internal <= 1'b1;
                            end

                            default: begin
                                Rin_internal <= 4'b0000; // LOAD_B
                                Rout_internal <= 4'b0001 << Rx;
                                Ain_internal <= 1'b1;
                                Gin_internal <= 1'b0;
                                Gout_internal <= 1'b0;
                                externx_internal <= 1'b0;
                                done_internal <= 1'b0;
                            end
                        endcase
                    end else begin
                        Rin_internal <= 4'b0000;
                        Rout_internal <= 4'b0000;
                        Ain_internal <= 1'b0;
                        Gin_internal <= 1'b0;
                        Gout_internal <= 1'b0;
                        externx_internal <= 1'b0;
                        done_internal <= 1'b0;
                    end
                end
                
                LOAD_B: begin           
                    Ain_internal <= 1'b0;
                    Rout_internal <= 4'b0001 << Ry_internal;
                    addsub_internal <= (F_internal == 2'b10);
                    Gin_internal <= 1'b1;
                end
    
                OUTPUT_G: begin
                    Rout_internal <= 4'b0000;
                    Gin_internal <= 1'b0;
                    Gout_internal <= 1'b1;
                    Rin_internal <= 4'b0001 << Rx_internal;
                    done_internal <= 1'b1;
                end
    
                default: begin
                    Rin_internal <= 4'b0000;
                    Rout_internal <= 4'b0000;
                    Ain_internal <= 1'b0;
                    Gin_internal <= 1'b0;
                    Gout_internal <= 1'b0;
                    externx_internal <= 1'b0;
                    done_internal <= 1'b0;
                end
            endcase
        end
    end

    assign Done = done_internal;
    assign Rin = Rin_internal;
    assign Rout = Rout_internal;
    assign Ain = Ain_internal;
    assign Gin = Gin_internal;
    assign Gout = Gout_internal;
    assign addsub = addsub_internal;
    assign externx = externx_internal;

endmodule