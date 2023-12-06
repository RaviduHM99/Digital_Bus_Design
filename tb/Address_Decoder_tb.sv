module Address_Decoder_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic B_UTIL;
    logic [2:0] AD_SEL;
    logic A_ADD;
    logic B_BUS_OUT;
    logic B_SBSY; 
    logic SPL_4K_SEL;

    Address_Decoder dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("master_tb.vcd"); $dumpvars;
        RSTN <= 1'b0;
        @(posedge CLK); 
        #1 
        B_UTIL <= 1'b0; 
        A_ADD <= 1'b0; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b0; 
        #(CLK_PERIOD) //Select 4k split slave no busy
        RSTN <= 1'b1; 
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b1; 
        B_SBSY <= 1'b0;
         
        #(CLK_PERIOD) 
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b0; 

        #(CLK_PERIOD)
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b0; 
        B_BUS_OUT <= 1'b1; 
        B_SBSY <= 1'b0;
         
        #(CLK_PERIOD*2) //Select 4k no split slave no busy
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b0; 

        #(CLK_PERIOD)
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b1; 
        B_SBSY <= 1'b0;

        #(CLK_PERIOD)
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b0; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b0;

        #(CLK_PERIOD*2) //Select 2k no split slave no busy
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b1; 
        B_SBSY <= 1'b0; 

        #(CLK_PERIOD)
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b1; 
        B_SBSY <= 1'b0;
        
        #(CLK_PERIOD)
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b0; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b0;

        #(CLK_PERIOD*2) //Select 4k split slave busy
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b1; 
        B_SBSY <= 1'b1; 

        #(CLK_PERIOD)
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b1;
        
        #(CLK_PERIOD) //activate SPL_$K_SEL
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b0; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b1;

        #(CLK_PERIOD*2) //Select 4k no split slave - split slave busy
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b1; 

        #(CLK_PERIOD)
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b1; 
        B_BUS_OUT <= 1'b1; 
        B_SBSY <= 1'b1;
        
        #(CLK_PERIOD) //deactivate SPL_$K_SEL
        B_UTIL <= 1'b1; 
        A_ADD <= 1'b0; 
        B_BUS_OUT <= 1'b0; 
        B_SBSY <= 1'b1;
        #(CLK_PERIOD*3) 
        $finish();
    end
    
endmodule