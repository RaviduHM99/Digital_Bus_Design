`timescale 1ns/1ps

module slvae_2K_00(
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

    input logic B_UTIL,
    output logic B_ACK,
    input logic B_RW,
    //output logic B_DONE,//need to add ack when read over to slave to bus
    output logic B_BUS_IN,
    input logic B_BUS_OUT
);

enum logic [2:0] { IDLE, ADDRESS, ACKNAR, WRITE, ACKNWR, READ, HOLD } state;

always_ff @( posedge CLK ) begin 
    if (RSTN)
    else begin
        unique case (state)
            IDLE:
        endcase
    end
end


endmodule