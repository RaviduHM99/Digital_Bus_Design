`timescale 1ns/1ps

module bus_arbiter(
    input logic CLK,
    input logic RSTN,

    input logic [1:0] B_REQ,
    output logic [1:0] B_GRANT,
    input logic B_UTIL,
    input logic [2:0] B_SBSY,

    output logic B_SPLIT
);
    enum logic [2:0] { IDLE, REQ_GRANT, SPLIT } state;

    always_ff @( posedge CLK or negedge RSTN ) begin
        if (!RSTN) begin
            
        end
        else begin
            
        end
    end
endmodule