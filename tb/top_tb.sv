module top_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic [1:0] M_DVALID, M_BSY, M_RW, M_EXECUTE, M_HOLD;

    logic [2:0] S_DVALID; 
    logic [7:0] S_DOUT;
    logic S_SPLIT;

    logic [7:0] M_DOUT0;
    logic [7:0] M_DIN0;
    logic [15:0] M_ADDR0;

    logic [7:0] M_DOUT1;
    logic [7:0] M_DIN1;
    logic [15:0] M_ADDR1;

    logic [2:0] S_DVALID; 
    logic [7:0] S_DOUT0;
    logic [7:0] S_DOUT1;
    logic [7:0] S_DOUT2;

    top dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("master_tb.vcd"); $dumpvars;
        RSTN <= 1'b0;
        @(posedge CLK); 
        #1  M_HOLD <= 1'b0;
        #(CLK_PERIOD) 
        RSTN <= 1; 
/*
        //////// WRITE TRANSACTION //////// 
        M_DIN0 <= 8'b10101101;
        M_ADDR0 <= 16'b1101010101010110;

        M_DIN1 <= 8'd0;
        M_ADDR1 <= 16'd0;

        M_RW <= 2'b01;
        M_EXECUTE <= 2'b00;
        M_HOLD <= 2'b01;

        S_SPLIT <= 1'b0;

        #(CLK_PERIOD)
        M_EXECUTE <= 2'b01;
        #(CLK_PERIOD*19)
        #(CLK_PERIOD*2)
        #(CLK_PERIOD*10)
        #(CLK_PERIOD*1)
        #(CLK_PERIOD*2)
        M_HOLD <= 2'b00;
        M_EXECUTE <= 2'b00;
        #(CLK_PERIOD*8)

        //////// READ TRANSACTION ////////
        M_DIN1 <= 8'd0;
        M_ADDR1 <= 16'b1101010101010111;

        M_DIN0 <= 8'd0;
        M_ADDR0 <= 16'd0;

        M_RW <= 2'b00;
        M_EXECUTE <= 2'b00;
        M_HOLD <= 2'b10;

        S_SPLIT <= 1'b0;

        #(CLK_PERIOD)
        M_EXECUTE <= 2'b10;
        #(CLK_PERIOD*19)
        #(CLK_PERIOD*2)
        #(CLK_PERIOD*10)
        #(CLK_PERIOD*1)
        #(CLK_PERIOD*2)
        M_HOLD <= 2'b00;
        M_EXECUTE <= 2'b00;
        #(CLK_PERIOD*8) */

        //////// SPLIT READ TRANSACTION ////////
        M_DIN0 <= 8'd0;
        M_ADDR0 <= 16'b1101010101010101;

        M_DIN1 <= 8'd179;
        M_ADDR1 <= 16'b1101010101010111;

        M_RW <= 2'b00;
        M_EXECUTE <= 2'b00;
        M_HOLD <= 2'b11;

        S_SPLIT <= 1'b1;

        #(CLK_PERIOD)
        M_EXECUTE <= 2'b11;
        #(CLK_PERIOD*19)
        #(CLK_PERIOD*2)
        #(CLK_PERIOD*10)
        #(CLK_PERIOD*1)
        #(CLK_PERIOD*24)
        S_SPLIT <= 1'b0;
        #(CLK_PERIOD*14) 
        M_HOLD <= 2'b00;
        M_EXECUTE <= 2'b00;
        #(CLK_PERIOD*5) 
/*
        //////// SPLIT WRITE TRANSACTION ////////
        M_DIN0 <= 8'd0;
        M_ADDR0 <= 16'b1101010101010101;

        M_DIN1 <= 8'd179;
        M_ADDR1 <= 16'b1101010101010111;

        M_RW <= 2'b10;
        M_EXECUTE <= 2'b00;
        M_HOLD <= 2'b11;

        S_SPLIT <= 1'b1;

        #(CLK_PERIOD)
        M_EXECUTE <= 2'b11;
        #(CLK_PERIOD*19)
        #(CLK_PERIOD*2)
        #(CLK_PERIOD*10)
        #(CLK_PERIOD*1)
        #(CLK_PERIOD*24)
        S_SPLIT <= 1'b0;
        #(CLK_PERIOD*14) 
        M_HOLD <= 2'b00;
        M_EXECUTE <= 2'b00;
        #(CLK_PERIOD*5) */

        $finish();
    end
    
endmodule