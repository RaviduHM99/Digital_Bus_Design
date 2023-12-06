`timescale 1ns/1ps

module bus(
    input logic CLK,
    input logic RSTN,

    input logic [1:0] B_REQ,
    output logic [1:0] B_GRANT,
    input logic [2:0] B_SBSY,
    output logic B_SPLIT,
    output logic B_SPL_RESUME,
    input logic [1:0] B_DONEM,

    input logic [1:0] B_UTILM,
    output logic [2:0] AD_SEL,
    input logic [1:0] A_ADDM,
    input logic [1:0] B_BUS_OUTM,

    output logic [2:0] B_BUS_OUTS,
    input logic [2:0] B_BUS_INS,
    output logic [1:0] B_BUS_INM,

    input logic [2:0] B_READYS,
    output logic [1:0] B_READYM,

    input logic [2:0] B_ACKS,
    output logic [1:0] B_ACKM,

    input logic [1:0] B_RWM,
    output logic [2:0] B_RWS
);
    logic B_DONE;
    logic A_ADD;
    logic B_BUS_OUT;
    logic B_UTIL;
    logic B_READY;
    logic B_ACK;
    logic B_BUS_IN;
    wire SPL_4K_SEL;
    logic B_RW;

    assign B_BUS_OUT = B_BUS_OUTM[0] | B_BUS_OUTM[1];
    assign B_BUS_OUTS = {3{B_BUS_OUT}};

    assign A_ADD = A_ADDM[0] | A_ADDM[1];

    assign B_BUS_IN = B_BUS_INS[0] | B_BUS_INS[1] | B_BUS_INS[2];
    assign B_BUS_INM = {2{B_BUS_IN}};

    assign B_DONE = B_DONEM[0] | B_DONEM[1];
    assign B_UTIL = B_UTILM[0] | B_UTILM[1];

    assign B_READY = B_READYS[0] | B_READYS[1] | B_READYS[2];
    assign B_READYM = {2{B_READY}};

    assign B_ACK = B_ACKS[0] | B_ACKS[1] | B_ACKS[2];
    assign B_ACKM = {2{B_ACK}};

    assign B_RW = B_RWM[0] | B_RWM[1];
    assign B_RWS = {3{B_RW}};

    bus_arbiter BA (
        .CLK(CLK),
        .RSTN(RSTN),
        .B_REQ(B_REQ),
        .B_GRANT(B_GRANT),
        .B_UTIL(B_UTIL),
        .B_SBSY(B_SBSY),
        .B_SPLIT(B_SPLIT),
        .B_SPL_RESUME(B_SPL_RESUME),
        .B_DONE(B_DONE),
        .SPL_4K_SEL(SPL_4K_SEL)
    );

    Address_Decoder AD (
        .CLK(CLK),
        .RSTN(RSTN),
        .B_UTIL(B_UTIL),
        .AD_SEL(AD_SEL),
        .A_ADD(A_ADD),
        .B_BUS_OUT(B_BUS_OUT),
        .B_SBSY(B_SBSY[0]),
        .SPL_4K_SEL(SPL_4K_SEL)
    );
endmodule