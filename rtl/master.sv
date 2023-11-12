`timescale 1ns/1ps

module master(
    input logic CLK,
    input logic RSTN,

    output logic M_DVALID, 
    output logic M_BSY,
    output logic [7:0] M_DOUT,
    input logic [7:0] M_DIN,
    input logic [14:0] M_ADDR,
    input logic M_RW,
    input logic M_EXECUTE,
    input logic M_HOLD,

    output logic B_UTIL,
    input logic B_ACK,
    output logic B_RW,
    output logic B_REQ,
    input logic B_GRANT, 
    inout logic B_BUS
);
    enum logic [2:0] { IDLE, ADDRESS, ACKN, WRITE, READ, HOLD } state;

    localparam WIDTH = 8;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .clk(CLK), .incr(incr), .count(count))

    always_comb begin
        B_REQ <= (M_HOLD) ? 1'b1 : 1'b0;
        M_BSY <= (B_GRANT) ? 1'b0 : 1'b1;



    end

    always @( posedge CLK or posedge RSTN) begin
        if (RSTN) begin
            state <= IDLE;
            rst <= 1'b0;
            incr <= 1'b0;
        end
        else begin
            unique case (state)
                IDLE : 
                ADDRESS : 
                ACKN :
                WRITE :
                READ :
                HOLD :
            endcase
        end
endmodule