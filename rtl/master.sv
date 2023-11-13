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
    inout logic B_BUS
);
    enum logic [2:0] { IDLE, ADDRESS, ACKNAR, WRITE, ACKNWR, READ, HOLD } state, ackad_state, ackwr_state, rd_state;

    localparam WIDTH = 8;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .clk(CLK), .incr(incr), .count(count));

    reg [15:0] REG_ADDRESS;
    reg [7:0] REG_DATAIN;
    reg [7:0] REG_DATAOUT;

    assign REG_ADDRESS = M_ADDR;
    assign REG_DATAIN = M_DIN;
    assign M_DOUT = REG_DATAOUT;

    always_comb begin
        B_REQ = (M_HOLD) ? 1'b1 : 1'b0;
        M_BSY = (B_GRANT) ? 1'b0 : 1'b1;

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
            rst <= 1'b0;
            incr <= 1'b0;
            REG_ADDRESS <= 16'd0;
            REG_DATAIN <= 8'd0;
            REG_DATAOUT <= 8'd0;
        end
        else begin
            unique case (state)
                IDLE : 

                ADDRESS : begin
                    B_RW <= M_RW;
                    B_BUS <= REG_ADDRESS[15];
                    incr <= (M_EXECUTE) ? 1'b1 : 1'b0;
                    REG_ADDRESS <= (M_EXECUTE) ? REG_ADDRESS << 1 : REG_ADDRESS;
                    state <= (count != 15) ? ADDRESS : ACKNAR;
                    rst <= (count == 15) ? 1'b1 : 1'b0;
                end

                ACKNAR : begin
                    B_RW <= M_RW;
                    rst <= (count == 3) ? 1'b1 : 1'b0;
                    state <= (count == 3) ? ackad_state : ACKNAR;
                    incr <= (M_EXECUTE) ? 1'b1 : 1'b0;
                end

                WRITE : begin
                    B_RW <= M_RW;
                    B_BUS <= REG_DATAIN[7];
                    REG_DATAIN <= (M_EXECUTE) ? REG_DATAIN << 1 : REG_DATAIN;
                    rst <= (count == 7) ? 1'b1 : 1'b0;
                    state <= (count == 7) ? ;
                    incr <= (M_EXECUTE) ? 1'b1 : 1'b0;
                end

                ACKNWR : begin
                    B_RW <= M_RW;
                    rst <= (count == 3) ? 1'b1 : 1'b0;
                    state <= (count == 3) ? ackwr_state : ACKNWR;
                    incr <= (M_EXECUTE) ? 1'b1 : 1'b0;
                end

                READ : begin
                    B_RW <= M_RW;
                    rst <= (count == 7) ? 1'b1 : 1'b0;
                    state <= (count == 7) ? IDLE : rd_state;
                    incr <= (M_EXECUTE) ? 1'b1 : 1'b0;
                    REG_DATAOUT[7] <= B_BUS;
                    REG_DATAOUT <= (M_EXECUTE) ? REG_DATAOUT >> 1 : REG_DATAOUT;
                end

                HOLD : begin
                    state <= (B_GRANT) ? READ : HOLD;
                end
            endcase
        end
endmodule