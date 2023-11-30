`timescale 1ns/1ps

module master(
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
    output logic B_REQ,
    input logic B_GRANT, 
    inout B_BUS
);
    enum logic [2:0] { IDLE, ADDRESS, ACKNAR, WRITE, ACKNWR, READ, HOLD } state, ackad_state, ackwr_state, rd_state;

    localparam WIDTH = 8;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .CLK(CLK), .incr(incr), .count(count));

    reg [15:0] REG_ADDRESS;
    reg [7:0] REG_DATAIN;
    reg [7:0] REG_DATAOUT;

    assign REG_ADDRESS = M_ADDR;
    assign REG_DATAIN = M_DIN;
    assign M_DOUT = REG_DATAOUT;

    logic B_BUS_INOUT;
    logic B_UTIL_CHECK;
    logic B_BUS_RD;

    assign B_BUS = (B_UTIL_CHECK & M_RW) ? B_BUS_INOUT : 1'bz;
    assign B_UTIL = B_UTIL_CHECK;

    assign B_BUS_RD = (M_RW) ? 1'bz : B_BUS;

    always_comb begin
        B_REQ = (M_HOLD) ? 1'b1 : 1'b0;
        M_BSY = (B_GRANT & M_HOLD) ? 1'b1 : 1'b0;

        unique case (M_RW)
            1'b0 : ackad_state = (B_ACK) ? READ : ADDRESS;
            1'b1 : ackad_state = (B_ACK) ? WRITE : ADDRESS;
        endcase
        ackwr_state = (B_ACK) ? IDLE : WRITE;
        rd_state = (B_GRANT) ? READ : HOLD;
    end

    always @( posedge CLK or posedge RSTN) begin
        if (RSTN) begin
            state <= IDLE;
            B_RW <= 1'b0;
            rst <= 1'b1;
            incr <= 1'b0;
            B_UTIL_CHECK <= 1'b0;
            M_DVALID <= 1'b0;
            B_BUS_INOUT <= 1'b0;
        end
        else begin
            unique case (state)
                IDLE : begin
                    state <= (M_BSY) ? ADDRESS : IDLE;
                    rst <= 1'b0;
                    B_UTIL_CHECK <= 1'b0;
                    incr <= (M_BSY) ? 1'b1 : 1'b0;
                end

                ADDRESS : begin
                    B_RW <= M_RW;
                    B_UTIL_CHECK <= 1'b1;
                    B_BUS_INOUT <= REG_ADDRESS[count];
                    incr <= 1'b1;
                    state <= (count != 15) ? ADDRESS : ACKNAR;
                    rst <= (count == 14) ? 1'b1 : 1'b0;
                    M_DVALID <= 1'b0;
                end

                ACKNAR : begin
                    B_RW <= M_RW;
                    B_UTIL_CHECK <= 1'b0;
                    rst <= (count == 2) ? 1'b1 : 1'b0;
                    state <= (count == 3) ? ackad_state : ACKNAR;
                    incr <= 1'b1;
                    M_DVALID <= 1'b0;
                end

                WRITE : begin
                    B_RW <= M_RW;
                    B_UTIL_CHECK <= 1'b1;
                    B_BUS_INOUT <= REG_DATAIN[count];
                    rst <= (count == 6) ? 1'b1 : 1'b0;
                    state <= (count != 7) ? WRITE : ACKNWR;
                    incr <= 1'b1;
                    M_DVALID <= 1'b0;
                end

                ACKNWR : begin
                    B_RW <= M_RW;
                    B_UTIL_CHECK <= 1'b0;
                    rst <= (count == 2) ? 1'b1 : 1'b0;
                    state <= (count == 3) ? ackwr_state : ACKNWR;
                    M_DVALID <= (count == 3) ? B_ACK : 1'b0;
                    incr <= 1'b1;
                end

                READ : begin
                    B_RW <= M_RW;
                    B_UTIL_CHECK <= 1'b1;
                    rst <= (count == 6) ? 1'b1 : 1'b0;
                    state <= (count == 7) ? IDLE : rd_state;
                    M_DVALID <= (count == 7) ? 1'b1 : 1'b0;
                    incr <= 1'b1;
                    REG_DATAOUT[count] <= B_BUS_RD; ///inverse problem
                end

                HOLD : begin
                    B_UTIL_CHECK <= 1'b0;
                    B_RW <= M_RW;
                    state <= (B_GRANT) ? READ : HOLD;
                end
            endcase
        end
    end
endmodule