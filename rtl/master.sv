`timescale 1ns/1ps

module master(
    input logic CLK,
    input logic RST,

    input logic U_REQ, // USER Inputs
    input logic U_LOCK,
    input logic U_WRITE,
    input logic [11:0] U_ADDR,
    input logic [31:0] U_WDATA,
    input logic [1:0] U_SLAVE,

    input logic HGRANT,
    input logic HREADY,
    input logic [1:0] HRESP,
    input logic HRDATA, // DATA READ

    output logic HREQ,
    output logic HLOCK,
    output logic HADDR,
    output logic HWDATA, // DATA READ
);
    
endmodule