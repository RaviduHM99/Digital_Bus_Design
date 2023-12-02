`timescale 1ns/1ps

module slvae_2K(
    input logic CLK,
    input logic RSTN,

    output logic M_DVALID, 
    output logic M_BSY,
    output logic [7:0] M_DOUT,
    input logic [7:0] M_DIN,
    input logic [15:0] M_ADDR,
    input logic M_RW,
    input logic M_EXECUTE,
    input logic M_HOLD,

    output logic B_UTIL,
    input logic B_ACK,
    output logic B_RW,
    output logic B_DONE,//need to add ack when read over to slave to bus
    input logic B_BUS_IN,
    output logic B_BUS_OUT
);

endmodule