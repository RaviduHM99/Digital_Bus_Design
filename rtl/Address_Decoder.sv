`timescale 1ns/1ps

module Address_Decoder(
    input logic CLK,
    input logic RSTN,

    input logic B_UTIL,
    output logic [3:0] AD_SEL,
    input logic A_ADD,
    input logic B_BUS_OUT,
    input logic B_SBSY, //split one
    output logic SPL_4K_SEL
);
    reg [1:0] SLAVE_SEL;
    logic valid;
    always_comb begin
        unique case (SLAVE_SEL)
            2'd1 : AD_SEL = (valid & ~B_SBSY) ? 3'b001 : 3'b0;
            2'd2 : AD_SEL = (valid) ? 3'b010 : 3'b0;
            2'd3 : AD_SEL = (valid) ? 3'b100 : 3'b0;
            default : AD_SEL = 3'b0;
        endcase
        SPL_4K_SEL = (valid & SLAVE_SEL == 2'd1) ? 1'b1 : 1'b0;
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
            valid <= 1'b0;
        end
        else begin
            rst <= (~A_ADD) ? 1'b1 : 1'b0;
            incr <= (B_UTIL & A_ADD) ? 1'b1 : 1'b0;
            if (B_UTIL & count == 1) valid <= 1'b1;
            else if (B_UTIL) valid <= valid;
            else valid <= 1'b0;
            SLAVE_SEL[count] <= (B_UTIL & A_ADD) ? B_BUS_OUT : SLAVE_SEL[count];
        end
    end

endmodule