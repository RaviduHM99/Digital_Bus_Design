module top_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic M_DVALID, M_BSY;
    logic [7:0] M_DOUT, M_DIN;
    logic [15:0] M_ADDR;
    logic M_RW, M_EXECUTE, M_HOLD;

    logic S_DVALID; 
    logic [7:0] S_DOUT;
    logic S_SPLIT;

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

        //////// WRITE TRANSACTION //////// 
        M_DIN <= 8'b10101101;
        M_ADDR <= 16'b1101010101010101;
        M_RW <= 1'b1;
        M_EXECUTE <= 1'b0;
        M_HOLD <= 1'b1;

        S_SPLIT <= 1'b0;

        #(CLK_PERIOD)
        M_EXECUTE <= 1'b1;
        #(CLK_PERIOD*19)
        #(CLK_PERIOD*2)
        #(CLK_PERIOD*10)
        #(CLK_PERIOD*1)
        #(CLK_PERIOD*1)
        M_HOLD <= 1'b0;
        M_EXECUTE <= 1'b0;
        #(CLK_PERIOD*3) 
/*
        //////// READ TRANSACTION ////////
        M_ADDR <= 16'b1101010101010101;
        M_RW <= 1'b0;
        M_EXECUTE <= 1'b0;
        M_HOLD <= 1'b1;

        B_ACK <= 1'b0;
        B_SBSY <= 3'b0;

        #(CLK_PERIOD)
        M_EXECUTE <= 1'b1;
        B_SBSY <= 3'b010;

        #(CLK_PERIOD*19)
        B_ACK <= 1'b1;
        #(CLK_PERIOD*1)
        B_BUS_IN <= 1'b1;
        #(CLK_PERIOD)
        
        B_BUS_IN <= 1'b0;
        #(CLK_PERIOD)
        B_ACK <= 1'b0;
        B_BUS_IN <= 1'b1;
        #(CLK_PERIOD)
        B_BUS_IN <= 1'b0;
        #(CLK_PERIOD)
        B_BUS_IN <= 1'b1;
        #(CLK_PERIOD)
        B_BUS_IN <= 1'b1;
        #(CLK_PERIOD)
        B_BUS_IN <= 1'b0;
        #(CLK_PERIOD)
        B_BUS_IN <= 1'b1;
        #(CLK_PERIOD)
        B_BUS_IN <= 1'bz;
        B_SBSY <= 3'b010;
        M_HOLD <= 1'b0;
        M_EXECUTE <= 1'b0;
        #(CLK_PERIOD*9)*/
        $finish();
    end
    
endmodule