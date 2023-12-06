module bus_arbiter_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic [1:0] B_REQ;
    logic [1:0] B_GRANT;
    logic B_UTIL;
    logic [2:0] B_SBSY;

    logic B_SPLIT;
    logic B_SPL_RESUME;
    logic SPL_4K_SEL;
    logic B_DONE;

    bus_arbiter dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("master_tb.vcd"); $dumpvars;
        RSTN <= 1'b0;
        @(posedge CLK); 
        #1 
        B_REQ <= 2'b00; 
        B_UTIL <= 1'b0; 
        B_SBSY <= 3'b000; 
        SPL_4K_SEL <= 1'b0;
        B_DONE <= 1'b0; 
        #(CLK_PERIOD) 
        RSTN <= 1'b1; 
        B_REQ <= 2'b01; 
        B_UTIL <= 1'b0; 
        B_SBSY <= 3'b000; 
        SPL_4K_SEL <= 1'b0; 

        #(CLK_PERIOD) 
        B_REQ <= 2'b01; 
        B_UTIL <= 1'b1; 
        B_SBSY <= 3'b000; 
        SPL_4K_SEL <= 1'b0; 

        #(CLK_PERIOD*4) 
        B_REQ <= 2'b00; 
        B_UTIL <= 1'b0; 
        B_SBSY <= 3'b010; 
        SPL_4K_SEL <= 1'b0;
        B_DONE <= 1'b1; 

        #(CLK_PERIOD*3) 
        B_DONE <= 1'b0;
        B_REQ <= 2'b10; 
        B_UTIL <= 1'b0; 
        B_SBSY <= 3'b100; 
        SPL_4K_SEL <= 1'b0;
        #(CLK_PERIOD) 
        B_REQ <= 2'b11; 
        B_UTIL <= 1'b1; 
        B_SBSY <= 3'b001; 
        SPL_4K_SEL <= 1'b0;
            #(CLK_PERIOD*5) 
        B_REQ <= 2'b11; 
        B_UTIL <= 1'b0; 
        B_DONE <= 1'b1;
        B_SBSY <= 3'b000; 
        SPL_4K_SEL <= 1'b0;
        #(CLK_PERIOD*7)
        $finish();
    end
    
endmodule