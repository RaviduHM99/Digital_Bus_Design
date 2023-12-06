module bus_tb;
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
    logic B_DONE;

    logic [2:0] AD_SEL;
    logic A_ADD;
    logic B_BUS_OUT;

    bus dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        RSTN <= 1'b0;
        @(posedge CLK); 
        #1
        RSTN <= 0; 
        B_REQ <= 0;
        B_UTIL <= 0;
        B_SBSY <= 0;
        B_DONE <= 0;
        A_ADD <= 0;
        B_BUS_OUT <= 0;
        #(CLK_PERIOD) 

        RSTN <= 1; 
        B_REQ <= 2'b00;
        B_UTIL <= 1'b0;
        B_SBSY <= 3'b000;
        B_DONE <= 1'b0;
        A_ADD <= 1'b0;
        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD)

        B_REQ <= 2'b01;
        B_UTIL <= 1'b0;
        B_SBSY <= 3'b000;
        B_DONE <= 1'b0;
        A_ADD <= 1'b0;
        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD)

        B_REQ <= 2'b01;
        B_UTIL <= 1'b1;
        B_SBSY <= 3'b000;
        B_DONE <= 1'b0;
        A_ADD <= 1'b1;
        B_BUS_OUT <= 1'b1;
        #(CLK_PERIOD)  
        B_REQ <= 2'b01;
        B_UTIL <= 1'b1;
        B_SBSY <= 3'b000;
        B_DONE <= 1'b0;
        A_ADD <= 1'b1;
        B_BUS_OUT <= 1'b0;
        #(CLK_PERIOD)   
        A_ADD <= 1'b0;      
        #(CLK_PERIOD*4) 
        $finish();
    end
    
endmodule