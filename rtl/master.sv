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

    output logic A_ADD,

    output logic B_UTIL,
    input logic B_ACK,
    output logic B_RW,
    output logic B_REQ,
    output logic B_DONE, 
    input logic B_GRANT,  
    input logic B_BUS_IN,
    output logic B_BUS_OUT
);
    enum logic [2:0] { IDLE, ADDRESS, ACKNAR, WRITE, ACKNWR, READ, HOLD } state, add_state, ackad_state, ackwr_state, rd_state;

    localparam WIDTH = 4;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .CLK(CLK), .incr(incr), .count(count));

    reg [15:0] REG_ADDRESS;
    reg [7:0] REG_DATAIN;
    reg [7:0] REG_DATAOUT;

    assign M_DOUT = REG_DATAOUT;
    
    logic Index_RD;
    assign Index_RD = 4'd7 - count;

    always_comb begin
        B_REQ = (M_HOLD) ? 1'b1 : 1'b0;
        M_BSY = (B_GRANT & M_HOLD) ? 1'b1 : 1'b0;

        unique case (M_RW)
            1'b0 : ackad_state = (B_ACK) ? READ : ADDRESS;
            1'b1 : ackad_state = (B_ACK) ? WRITE : ADDRESS;
        endcase
        add_state = (B_GRANT) ? ACKNAR : IDLE;
        ackwr_state = (B_ACK) ? IDLE : WRITE;
        rd_state = (B_GRANT) ? READ : HOLD;
        B_RW = M_RW;
    end

    always @( posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            state <= IDLE;
            rst <= 1'b1;
            incr <= 1'b0;
            B_UTIL <= 1'b0;
            REG_ADDRESS <= 16'd0;
            REG_DATAIN <= 8'd0;
            REG_DATAOUT <= 8'd0;
            B_BUS_OUT <= 1'b0;
            A_ADD <= 1'b0;
            B_DONE <= 1'b0;
        end
        else begin
            B_UTIL <= 1'b0;
            incr <= (M_EXECUTE & B_GRANT) ? 1'b1 : 1'b0;
            A_ADD <= 1'b0;
            REG_ADDRESS <= M_ADDR;
            REG_DATAIN <= M_DIN;
            B_BUS_OUT <= 1'b0;
            
            unique case (state)
                IDLE : begin
                    state <= (M_EXECUTE & B_GRANT) ? ADDRESS : IDLE;
                    rst <= 1'b0;
                    B_DONE <= (M_EXECUTE) ? 1'b0 : B_DONE;
                end

                ADDRESS : begin
                    B_UTIL <= 1'b1;
                    B_BUS_OUT <= REG_ADDRESS[count];
                    state <= (count != 15 & B_GRANT) ? ADDRESS : add_state;
                    rst <= (count == 14 | ~B_GRANT) ? 1'b1 : 1'b0;
                    A_ADD <= (count < 2) ? 1'b1 : 1'b0;
                    B_DONE <= 1'b0;
                end

                ACKNAR : begin
                    B_UTIL <= 1'b1;
                    rst <= (count == 2 | B_ACK) ? 1'b1 : 1'b0;
                    state <= (count == 3 | B_ACK) ? ackad_state : ACKNAR;
                    B_DONE <= 1'b0;
                end

                WRITE : begin
                    B_UTIL <= 1'b1;
                    B_BUS_OUT <= REG_DATAIN[count];
                    rst <= (count == 6) ? 1'b1 : 1'b0;
                    state <= (count != 7) ? WRITE : ACKNWR;
                    B_DONE <= 1'b0;
                end

                ACKNWR : begin
                    B_UTIL <= 1'b1;
                    rst <= (count == 2) ? 1'b1 : 1'b0;
                    state <= (count == 3) ? ackwr_state : ACKNWR;
                    M_DVALID <= (count == 3) ? B_ACK : 1'b0;
                    B_DONE <= (B_ACK) ? 1'b1 : 1'b0;
                end

                READ : begin
                    B_UTIL <= (B_GRANT) ? 1'b1 : 1'b0;
                    rst <= (count == 6 | ~B_GRANT) ? 1'b1 : 1'b0;
                    state <= (count == 7) ? IDLE : rd_state;
                    M_DVALID <= (count == 7) ? 1'b1 : 1'b0;
                    REG_DATAOUT[count] <= B_BUS_IN;
                    B_DONE <= (count == 7) ? 1'b1 : 1'b0;
                end

                HOLD : begin
                    state <= (B_GRANT) ? READ : HOLD;
                    rst <= 1'b0;
                end
            endcase
        end
    end
endmodule