`timescale 1ns/1ps

module top(
    input logic CLK,
    input logic RSTN,

    input logic [2:0] B_SBSY,
    output logic B_SPLIT,
    output logic B_SPL_RESUME,
    output logic [2:0] AD_SEL,
    output logic M_DVALID, 
    output logic M_BSY,
    output logic [7:0] M_DOUT,
    input logic [7:0] M_DIN,
    input logic [15:0] M_ADDR,
    input logic M_RW,
    input logic M_EXECUTE,
    input logic M_HOLD,
    input logic B_ACK,
    output logic B_RW,
    input logic B_BUS_IN

);
    wire B_UTIL;
    wire B_BUS_OUT;
    wire A_ADD;
    logic [1:0] B_GRANT;
    wire B_DONE;
    logic [1:0] B_REQ;

    assign B_GRANT[1] = 1'b0;
    assign B_REQ[1] = 1'b0;

    master M_dut (
        .CLK(CLK),
        .RSTN(RSTN),

        .M_DVALID(M_DVALID), 
        .M_BSY(M_BSY),
        .M_DOUT(M_DOUT),
        .M_DIN(M_DIN),
        .M_ADDR(M_ADDR),
        .M_RW(M_RW),
        .M_EXECUTE(M_EXECUTE),
        .M_HOLD(M_HOLD),
        .A_ADD(A_ADD),
        .B_UTIL(B_UTIL),
        .B_ACK(B_ACK),
        .B_RW(B_RW),
        .B_REQ(B_REQ),
        .B_DONE(B_DONE), 
        .B_GRANT(B_GRANT),  
        .B_BUS_IN(B_BUS_IN),
        .B_BUS_OUT(B_BUS_OUT)
    );

    bus B_dut (
        .CLK(CLK),
        .RSTN(RSTN),
        .B_REQ(B_REQ),
        .B_GRANT(B_GRANT),
        .B_UTIL(B_UTIL),
        .B_SBSY(B_SBSY),
        .B_SPLIT(B_SPLIT),
        .B_SPL_RESUME(B_SPL_RESUME),
        .B_DONE(B_DONE),
        .AD_SEL(AD_SEL),
        .A_ADD(A_ADD),
        .B_BUS_OUT(B_BUS_OUT)
    );


endmodule