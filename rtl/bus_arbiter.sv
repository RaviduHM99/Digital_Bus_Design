`timescale 1ns/1ps

module bus_arbiter(
    input logic CLK,
    input logic RSTN,

    input logic [1:0] B_REQ,
    output logic [1:0] B_GRANT,
    input logic B_UTIL,
    input logic [2:0] B_SBSY,

    output logic B_SPLIT,
    output logic B_SPL_RESUME,
    input logic B_DONE,
    input logic SPL_4K_SEL
);
    enum logic [2:0] { IDLE, REQ_GRANT, UTIL, SPLIT, SPLIT_UTIL, SPLIT_RESUME} state, next_state;

    logic [1:0] MAS_GRANT;
    always_comb begin
        next_state = (B_SBSY[0] == 1'b1) ? SPLIT : IDLE; 
        B_SPLIT = (B_SBSY[0] == 1'b1) ? 1'b1 : 1'b0; 
        
    end

    reg [1:0] MASTER_REQ_OLD;

    always_ff @( posedge CLK or negedge RSTN ) begin
        if (!RSTN) begin
            state <= IDLE;
            B_GRANT <= 2'b00;
            MASTER_REQ_OLD <= 2'b00;
            B_SPL_RESUME <= 1'b0;
        end
        else begin
            MASTER_REQ_OLD <= MASTER_REQ_OLD;
            B_SPL_RESUME <= 1'b0;
            unique case (state)
                IDLE : begin
                    state <= (B_REQ == 2'b00 | B_DONE) ? IDLE : REQ_GRANT;
                    B_GRANT <= 2'b00;
                end
                REQ_GRANT : begin
                    MASTER_REQ_OLD <= (B_REQ != 2'b11) ? B_REQ : 2'b01;
                    state <= (B_UTIL) ? UTIL : REQ_GRANT;
                    if (B_REQ == 2'b11) B_GRANT <= 2'b01;
                    else B_GRANT <= B_REQ;
                end
                UTIL : begin
                    state <= (B_SBSY[0] != 1'b1 & ~B_DONE) ? UTIL : next_state;
                    B_GRANT <= (B_SBSY[0] == 1'b1 | B_DONE) ? 2'b00 : B_GRANT;
                end
                SPLIT : begin
                    state <= ((B_REQ == MASTER_REQ_OLD & B_SBSY[0]) | B_REQ == 2'b00) ? SPLIT : SPLIT_UTIL;
                    B_GRANT <= (B_REQ == 2'b00) ? 2'b00 : B_REQ ^ MASTER_REQ_OLD;
                end
                SPLIT_UTIL : begin
                    state <= (SPL_4K_SEL | B_DONE) ? SPLIT_RESUME : SPLIT_UTIL;
                    B_GRANT <= (SPL_4K_SEL | B_DONE) ? 2'b00 : B_GRANT;
                end
                SPLIT_RESUME : begin
                    state <= (B_DONE) ? IDLE : SPLIT_RESUME;
                    B_GRANT <= (B_DONE) ? 2'b00 : MASTER_REQ_OLD;
                    B_SPL_RESUME <= 1'b1;
                end
            endcase

        end
    end
endmodule