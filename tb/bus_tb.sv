module Processing_Element_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    Processing_Element #(.N(N)) dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        #(CLK_PERIOD*2)
        @(posedge CLK); 
        #1 RSTN <= 1; RST_MUL <= 1;
        #(CLK_PERIOD) 
        RSTN <= 0; 
        $finish();
    end
    
endmodule