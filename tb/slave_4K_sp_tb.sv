module slave_4K_sp_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic S_DVALID; 
    logic [7:0] S_DOUT;

    logic AD_SEL;
    
    logic B_ACK;
    logic B_RW;
    logic B_SBSY;
    logic B_BUS_IN;
    logic B_BUS_OUT;

    logic S_SPLIT;
    logic B_SPLIT;
    logic B_SPL_RESUME;

    slvae_4K_sp dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("master_tb.vcd"); $dumpvars;
        RSTN <= 1'b0;
        @(posedge CLK); 
        #1
        AD_SEL <= 1'b0;
        B_RW <= 1'b1;
        B_BUS_OUT <= 1'b0;
        S_SPLIT <= 1'b0;
        B_SPLIT <= 1'b0;
        B_SPL_RESUME <= 1'b0; 

        #(CLK_PERIOD) 
        RSTN <= 1; 
/*
        //////// WRITE TRANSACTION //////// 
        AD_SEL <= 1'b0;
        B_RW <= 1'b1;
        B_BUS_OUT <= 1'b1;

        #(CLK_PERIOD)
        AD_SEL <= 1'b1;
        B_RW <= 1'b1;
        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD)
        B_RW <= 1'b1;
        B_BUS_OUT <= 1'b1;
        #(CLK_PERIOD*13)
        B_RW <= 1'b1;
        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD)
        B_RW <= 1'b1;
        B_BUS_OUT <= 1'b1;
        #(CLK_PERIOD)
        AD_SEL <= 1'b1;
        B_RW <= 1'b1;
        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD*25)

*/
        //////// READ TRANSACTION ////////
        AD_SEL <= 1'b0;
        B_RW <= 1'b0;
        B_BUS_OUT <= 1'b1;
        S_SPLIT <= 1'b0;
        B_SPLIT <= 1'b0;
        B_SPL_RESUME <= 1'b0; 

        #(CLK_PERIOD)
        AD_SEL <= 1'b1;
        B_RW <= 1'b0;
        B_BUS_OUT <= 1'b0;

        #(CLK_PERIOD)

        B_BUS_OUT <= 1'b1;
        #(CLK_PERIOD*13)

        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD)

        B_BUS_OUT <= 1'b1;
        #(CLK_PERIOD)

        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD*25)
        $finish();
    end
    
endmodule