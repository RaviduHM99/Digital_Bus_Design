`timescale 1ns/1ps

module top(
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

    output logic S_DVALID, 
    output logic [7:0] S_DOUT,
    input logic S_SPLIT

);
    wire B_UTIL;
    wire B_BUS_OUT;
    wire A_ADD;
    logic [1:0] B_GRANT;
    wire B_DONE;
    logic [1:0] B_REQ;
    
    assign B_GRANT[1] = 1'b0;
    assign B_REQ[1] = 1'b0;

    wire B_ACK;
    wire B_RW;
    logic [2:0] B_SBSY;
    wire B_SPLIT;
    wire B_SPL_RESUME;
    wire B_BUS_IN;
    logic [2:0] AD_SEL;
    wire B_READY;
    assign B_SBSY[2:1] = 2'b0;

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
        .B_READY(B_READY), 
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

    slvae_4K_sp S1_dut (
        .CLK(CLK),
        .RSTN(RSTN),
        .S_DVALID(S_DVALID),
        .S_DOUT(S_DOUT),
        .S_SPLIT(S_SPLIT),
        .AD_SEL(AD_SEL[0]),
        .B_ACK(B_ACK),
        .B_RW(B_RW),
        .B_SBSY(B_SBSY[0]),
        .B_SPLIT(B_SPLIT),
        .B_READY(B_READY), 
        .B_SPL_RESUME(B_SPL_RESUME),
        .B_BUS_IN(B_BUS_IN),
        .B_BUS_OUT(B_BUS_OUT)
    );

endmodule