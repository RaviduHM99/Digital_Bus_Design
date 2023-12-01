module master_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic M_DVALID, M_BSY;
    logic [7:0] M_DOUT, M_DIN;
    logic [15:0] M_ADDR;
    logic M_RW, M_EXECUTE, M_HOLD;

    logic B_UTIL, B_ACK,B_RW, B_REQ, B_GRANT;
    logic B_BUS_IN;
    logic B_BUS_OUT;

    master dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("master_tb.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RSTN <= 1'b1; M_HOLD <= 1'b0;

        #(CLK_PERIOD) 
        RSTN <= 0; 
/*
        //////// WRITE TRANSACTION //////// 
        M_DIN <= 8'b10101101;
        M_ADDR <= 16'b1101010101010101;
        M_RW <= 1'b1;
        M_EXECUTE <= 1'b0;
        M_HOLD <= 1'b1;

        B_ACK <= 1'b0;
        B_GRANT <= 1'b0;

        #(CLK_PERIOD)
        M_EXECUTE <= 1'b1;
        B_GRANT <= 1'b1;

        #(CLK_PERIOD*19)
        B_ACK <= 1'b1;
        #(CLK_PERIOD*2)
        B_ACK <= 1'b0;
        #(CLK_PERIOD*10)
        B_ACK <= 1'b1;
        #(CLK_PERIOD*1)
        B_GRANT <= 1'b0;
        #(CLK_PERIOD*1)
        B_ACK <= 1'b0;
        M_HOLD <= 1'b0;
        M_EXECUTE <= 1'b0;
        #(CLK_PERIOD*3) 
*/
        //////// READ TRANSACTION ////////
        M_ADDR <= 16'b1101010101010101;
        M_RW <= 1'b0;
        M_EXECUTE <= 1'b0;
        M_HOLD <= 1'b1;

        B_ACK <= 1'b0;
        B_GRANT <= 1'b0;

        #(CLK_PERIOD)
        M_EXECUTE <= 1'b1;
        B_GRANT <= 1'b1;

        #(CLK_PERIOD*19)
        B_ACK <= 1'b1;
        #(CLK_PERIOD*2)
        B_ACK <= 1'b0;
        B_BUS_IN <= 1'b1;
        #(CLK_PERIOD)
        B_BUS_IN <= 1'b0;
        #(CLK_PERIOD)
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
        B_GRANT <= 1'b0;
        M_HOLD <= 1'b0;
        M_EXECUTE <= 1'b0;
        #(CLK_PERIOD*3)
        $finish();
    end
    
endmodule