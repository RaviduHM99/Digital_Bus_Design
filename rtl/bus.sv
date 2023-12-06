`timescale 1ns/1ps

module bus(
    input logic CLK,
    input logic RSTN,

    input logic [1:0] B_REQ,
    output logic [1:0] B_GRANT,
    input logic B_UTIL,
    input logic [2:0] B_SBSY,

    output logic B_SPLIT,
    output logic B_SPL_RESUME,
    input logic B_DONE,

    output logic [2:0] AD_SEL,
    input logic A_ADD,
    input logic B_BUS_OUT


);
    wire SPL_4K_SEL;
    
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