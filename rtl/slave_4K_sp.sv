`timescale 1ns/1ps

module slvae_4K_sp(
    input logic CLK,
    input logic RSTN,

    output logic S_DVALID, 
    output logic [7:0] S_DOUT,
    input logic S_SPLIT,

    input logic AD_SEL,

    output logic B_ACK,
    input logic B_RW,
    output logic B_SBSY,
    output logic B_READY,
    input logic B_SPLIT,
    input logic B_SPL_RESUME,
    output logic B_BUS_IN,
    input logic B_BUS_OUT
);

    enum logic [2:0] { IDLE, ADDRESS, ACKNAR, WRITE, ACKNWR, READ, HOLD} state, Rd_state, Adr_state, Ackad_state;

    localparam WIDTH = 4;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .CLK(CLK), .incr(incr), .count(count));

    reg [14:0] REG_ADDRESS;
    reg [11:0] MEM_ADDRESS;
    reg [4095:0][7:0] MEM_SPACE; //2^12
    
    always_comb begin
        Adr_state = (AD_SEL) ? ACKNAR : IDLE;
        Rd_state = (B_SPLIT & ~B_SPL_RESUME) ? HOLD : READ;
        unique case (B_RW)
            1'b0 : Ackad_state = READ;
            1'b1 : Ackad_state = WRITE;
        endcase
    end

    assign MEM_ADDRESS = REG_ADDRESS[12:1];

always_ff @( posedge CLK or negedge RSTN) begin 
    if (!RSTN) begin
        rst <= 1'b1;
        MEM_SPACE <= {4096{8'hbf}}; // change this
        REG_ADDRESS <= 'd0;
        B_ACK <= 1'b0;
        B_BUS_IN <= 1'b0;
        S_DVALID <= 1'b0;
        S_DOUT <= 8'd0;
        incr <= 1'b0;
        B_SBSY <= 1'b0;
        state <= IDLE;
        B_READY <= 1'b0;
    end
    else begin
        incr <= (AD_SEL) ? 1'b1 : 1'b0;
        B_ACK <= 1'b0;
        S_DVALID <= 1'b0;
        REG_ADDRESS <= REG_ADDRESS;
        MEM_SPACE <= MEM_SPACE;
        B_BUS_IN <= 1'b0;
        B_SBSY <= 1'b0;
        S_DOUT <= S_DOUT;
        B_READY <= (AD_SEL) ? 1'b1 : 1'b0;
        unique case (state)
            IDLE : begin
                state <= (AD_SEL) ? ADDRESS : IDLE;
                REG_ADDRESS <= 16'd0;
                rst <= 1'b1;
            end
            ADDRESS : begin

                REG_ADDRESS[count] <= (count > 0 ) ? B_BUS_OUT : REG_ADDRESS[count];
                state <= (count != 14) ? ADDRESS : Adr_state;
                rst <= (count == 13) ? 1'b1 : 1'b0;
            end
            ACKNAR : begin

                B_ACK <= (count != 2) ? 1'b1 : 1'b0;
                rst <= (count == 2) ? 1'b1 : 1'b0;
                state <= (count == 2) ? Ackad_state : ACKNAR;  /// this count is warning
                B_SBSY <= (count == 2) ? S_SPLIT : 1'b0;
            end 
            WRITE : begin

                MEM_SPACE[MEM_ADDRESS[13:2]] <= B_BUS_OUT;
                rst <= (count == 6) ? 1'b1 : 1'b0;
                state <= (count != 7) ? WRITE : ACKNWR;
            end
            ACKNWR : begin
                S_DOUT <= MEM_SPACE[MEM_ADDRESS];
                B_ACK <= (count != 2) ? 1'b1 : 1'b0;
                rst <= (count == 1) ? 1'b1 : 1'b0;
                state <= (count == 2) ? IDLE : ACKNWR;
                S_DVALID <= (count == 2) ? 1'b1 : 1'b0;
            end
            READ : begin
                rst <= (count == 6) ? 1'b1 : 1'b0;
                state <= (count == 7) ? IDLE : Rd_state;
                B_BUS_IN <= MEM_SPACE[MEM_ADDRESS][count];
            end
            HOLD : begin
                state <= (B_SPLIT & ~B_SPL_RESUME) ? HOLD : READ;
                rst <= 1'b1;
            end
        endcase
    end
end


endmodule