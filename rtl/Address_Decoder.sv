`timescale 1ns/1ps

module Address_Decoder(
    input logic CLK,
    input logic RSTN,

    input logic B_UTIL,
    output logic [3:0] AD_SEL,
    input logic A_ADD,
    input logic B_BUS_OUT
);
    reg [1:0] SLAVE_SEL;
    always_comb begin
        unique case (SLAVE_SEL)
            2'd1 : AD_SEL <= 3'b001;
            2'd2 : AD_SEL <= 3'b010;
            2'd3 : AD_SEL <= 3'b100;
            default : AD_SEL <= 3'b0;
        endcase
    end

    localparam WIDTH = 4;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .CLK(CLK), .incr(incr), .count(count));

    always_ff @( posedge CLK or negedge RSTN ) begin
        if (!RSTN) begin
            SLAVE_SEL <= 2'b00;
            rst <= 1'b1;
            incr <= 1'b0;
        end
        else begin
            rst <= (~A_ADD) ? 1'b1 : 1'b0;
            incr <= (B_UTIL & A_ADD) ? 1'b1 : 1'b0;
            SLAVE_SEL[count] <= (B_UTIL & A_ADD) ? B_BUS_OUT : SLAVE_SEL[count];
        end
    end

endmodule