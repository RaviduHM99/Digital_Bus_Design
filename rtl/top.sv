`timescale 1ns/1ps

module top(
    input logic CLK,
    input logic RSTN,

    output logic [1:0] M_DVALID, 
    output logic [1:0] M_BSY,

    output logic [7:0] M_DOUT0,
    input logic [7:0] M_DIN0,
    input logic [15:0] M_ADDR0,

    output logic [7:0] M_DOUT1,
    input logic [7:0] M_DIN1,
    input logic [15:0] M_ADDR1,

    input logic [1:0] M_RW,
    input logic [1:0] M_EXECUTE,
    input logic [1:0] M_HOLD,

    output logic [2:0] S_DVALID, 
    output logic [7:0] S_DOUT0,
    output logic [7:0] S_DOUT1,
    output logic [7:0] S_DOUT2,

    input logic S_SPLIT
);

    wire [1:0] B_REQ;
    wire [1:0] B_GRANT;
    wire [2:0] B_SBSY;
    wire B_SPLIT;
    wire B_SPL_RESUME;
    wire  [1:0] B_DONEM;

    wire  [1:0] B_UTILM;
    wire  [2:0] AD_SEL;
    wire  [1:0] A_ADDM;
    wire  [1:0] B_BUS_OUTM;

    wire  [2:0] B_BUS_OUTS;
    wire  [2:0] B_BUS_INS;
    wire  [1:0] B_BUS_INM;

    wire  [2:0] B_READYS;
    wire  [1:0] B_READYM;

    wire  [2:0] B_ACKS;
    wire  [1:0] B_ACKM;

    wire  [1:0] B_RWM;
    wire  [2:0] B_RWS;

    master M1_dut (
        .CLK(CLK),
        .RSTN(RSTN),

        .M_DVALID(M_DVALID[0]), 
        .M_BSY(M_BSY[0]),
        .M_DOUT(M_DOUT0),
        .M_DIN(M_DIN0),
        .M_ADDR(M_ADDR0),
        .M_RW(M_RW[0]),
        .M_EXECUTE(M_EXECUTE[0]),
        .M_HOLD(M_HOLD[0]),
        .A_ADD(A_ADDM[0]),
        .B_UTIL(B_UTILM[0]),
        .B_ACK(B_ACKM[0]),
        .B_RW(B_RWM[0]),
        .B_REQ(B_REQ[0]),
        .B_DONE(B_DONEM[0]), 
        .B_GRANT(B_GRANT[0]), 
        .B_READY(B_READYM[0]), 
        .B_BUS_IN(B_BUS_INM[0]),
        .B_BUS_OUT(B_BUS_OUTM[0])
    );

    master M2_dut (
        .CLK(CLK),
        .RSTN(RSTN),

        .M_DVALID(M_DVALID[1]), 
        .M_BSY(M_BSY[1]),
        .M_DOUT(M_DOUT1),
        .M_DIN(M_DIN1),
        .M_ADDR(M_ADDR1),
        .M_RW(M_RW[1]),
        .M_EXECUTE(M_EXECUTE[1]),
        .M_HOLD(M_HOLD[1]),
        .A_ADD(A_ADDM[1]),
        .B_UTIL(B_UTILM[1]),
        .B_ACK(B_ACKM[1]),
        .B_RW(B_RWM[1]),
        .B_REQ(B_REQ[1]),
        .B_DONE(B_DONEM[1]), 
        .B_GRANT(B_GRANT[1]), 
        .B_READY(B_READYM[1]), 
        .B_BUS_IN(B_BUS_INM[1]),
        .B_BUS_OUT(B_BUS_OUTM[1])
    );

    bus B_dut (
        .CLK(CLK),
        .RSTN(RSTN),

        .B_REQ(B_REQ),
        .B_GRANT(B_GRANT),
        .B_SBSY(B_SBSY),
        .B_SPLIT(B_SPLIT),
        .B_SPL_RESUME(B_SPL_RESUME),
        .B_DONEM(B_DONEM),

        .B_UTILM(B_UTILM),
        .AD_SEL(AD_SEL),
        .A_ADDM(A_ADDM),
        .B_BUS_OUTM(B_BUS_OUTM),

        .B_BUS_OUTS(B_BUS_OUTS),
        .B_BUS_INS(B_BUS_INS),
        .B_BUS_INM(B_BUS_INM),

        .B_READYS(B_READYS),
        .B_READYM(B_READYM),

        .B_ACKS(B_ACKS),
        .B_ACKM(B_ACKM),

        .B_RWM(B_RWM),
        .B_RWS(B_RWS)
    );

    slave_4K_sp S0_dut (
        .CLK(CLK),
        .RSTN(RSTN),

        .B_SPLIT(B_SPLIT),
        .B_SPL_RESUME(B_SPL_RESUME),

        .S_SPLIT(S_SPLIT),

        .S_DVALID(S_DVALID[0]),
        .S_DOUT(S_DOUT0),
        .AD_SEL(AD_SEL[0]),
        .B_ACK(B_ACKS[0]),
        .B_RW(B_RWS[0]),
        .B_SBSY(B_SBSY[0]),
        .B_READY(B_READYS[0]), 
        .B_BUS_IN(B_BUS_INS[0]),
        .B_BUS_OUT(B_BUS_OUTS[0])
    );

    slave_4K S1_dut (
        .CLK(CLK),
        .RSTN(RSTN),

        .S_DVALID(S_DVALID[1]),
        .S_DOUT(S_DOUT1),
        .AD_SEL(AD_SEL[1]),
        .B_ACK(B_ACKS[1]),
        .B_RW(B_RWS[1]),
        .B_SBSY(B_SBSY[1]),
        .B_READY(B_READYS[1]), 
        .B_BUS_IN(B_BUS_INS[1]),
        .B_BUS_OUT(B_BUS_OUTS[1])
    );

    slave_2K S2_dut (
        .CLK(CLK),
        .RSTN(RSTN),

        .S_DVALID(S_DVALID[2]),
        .S_DOUT(S_DOUT2),
        .AD_SEL(AD_SEL[2]),
        .B_ACK(B_ACKS[2]),
        .B_RW(B_RWS[2]),
        .B_SBSY(B_SBSY[2]),
        .B_READY(B_READYS[2]), 
        .B_BUS_IN(B_BUS_INS[2]),
        .B_BUS_OUT(B_BUS_OUTS[2])
    );
endmodule