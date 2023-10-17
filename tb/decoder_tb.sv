module decoder_tb();
    timeunit 1ns;
    timeprecision 1ps;

    logic clk=0,rst=0;
    logic [16:0] HADDR;

    logic SEL_4K,SEL_2K1,SEL_2K2;
    logic [1:0] SELR;

    decoder dut (.*);

    localparam CLK_PERIOD = 10;
    initial forever #(CLK_PERIOD/2) clk <= ~clk;

    initial begin
         
    end
endmodule
