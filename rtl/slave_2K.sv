`timescale 1ns/1ps

module slave_2K(
    input logic CLK,
    input logic RSTN,

    output logic S_DVALID, 
    output logic [7:0] S_DOUT,

    input logic AD_SEL,
    
    output logic B_ACK,
    input logic B_RW,
    output logic B_SBSY,
    output logic B_READY,
    output logic B_BUS_IN,
    input logic B_BUS_OUT
);

    enum logic [2:0] { IDLE, ADDRESS, ACKNAR, WRITE, ACKNWR, READ} state, Adr_state, Ackad_state;

    localparam WIDTH = 4;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .CLK(CLK), .incr(incr), .count(count));

    logic rst1, incr1;
    logic [WIDTH-1:0] count1;
    counter #(.WIDTH(WIDTH)) counter1 (.rst(rst1), .CLK(CLK), .incr(incr1), .count(count1));

    reg [14:0] REG_ADDRESS;
    reg [11:0] MEM_ADDRESS;
    reg [2047:0][7:0] MEM_SPACE; //2^12
    
    always_comb begin
        Adr_state = (AD_SEL) ? ACKNAR : IDLE;

        unique case (B_RW)
            1'b0 : Ackad_state = READ;
            1'b1 : Ackad_state = WRITE;
        endcase
    end


always_ff @( posedge CLK or negedge RSTN) begin 
    if (!RSTN) begin
        rst <= 1'b1;
        rst1 <= 1'b1;
        MEM_SPACE <= {4096{8'had}}; 
        REG_ADDRESS <= 'd0;
        MEM_ADDRESS <= 12'd0;
        B_ACK <= 1'b0;
        B_BUS_IN <= 1'b0;
        S_DVALID <= 1'b0;
        S_DOUT <= 8'd0;
        incr <= 1'b0;
        incr1 <= 1'b0;
        B_SBSY <= 1'b0;
        state <= IDLE;
        B_READY <= 1'b0;
    end
    else begin
        incr <= 1'b0;
        incr1 <= 1'b0;
        rst1 <= 1'b0;
        B_ACK <= 1'b0;
        S_DVALID <= S_DVALID;
        REG_ADDRESS <= REG_ADDRESS;
        MEM_SPACE <= MEM_SPACE;
        B_BUS_IN <= 1'b0;
        B_SBSY <= 1'b0;
        S_DOUT <= S_DOUT;
        B_READY <= (AD_SEL) ? 1'b1 : 1'b0;
        MEM_ADDRESS <= MEM_ADDRESS;

        unique case (state)
            IDLE : begin
                state <= (AD_SEL) ? ADDRESS : IDLE;
                REG_ADDRESS <= 16'd0;
                rst <= 1'b0;
            end
            ADDRESS : begin
                B_SBSY <= 1'b1;
                incr <= (AD_SEL & ~rst) ? 1'b1 : 1'b0;
                REG_ADDRESS[count] <= B_BUS_OUT;
                state <= (count != 14 & AD_SEL) ? ADDRESS : Adr_state;
                rst <= (count == 13) ? 1'b1 : 1'b0;
            end 
            ACKNAR : begin
                B_SBSY <= 1'b1;
                S_DVALID <= (AD_SEL) ? 1'b0 : S_DVALID;
                incr <= (AD_SEL & ~rst & count < 1) ? 1'b1 : 1'b0;
                MEM_ADDRESS <= REG_ADDRESS[12:1];
                B_ACK <= (count < 1) ? 1'b1 : 1'b0;
                rst <= (count == 1) ? 1'b1 : 1'b0;
                state <= (count == 1) ? Ackad_state : ACKNAR;  /// this count is warning
                incr1 <= (AD_SEL & ~rst1 & ~B_RW & count == 1) ? 1'b1 : 1'b0;
            end 
            WRITE : begin
                B_SBSY <= 1'b1;
                incr1 <= (AD_SEL & ~rst1) ? 1'b1 : 1'b0;
                MEM_SPACE[MEM_ADDRESS][count1] <= B_BUS_OUT;
                rst1 <= (count1 == 6) ? 1'b1 : 1'b0;
                state <= (count1 != 7) ? WRITE : ACKNWR;
                rst <= 1'b0;
                incr <= (count == 7) ? 1'b1 : 1'b0;
            end
            ACKNWR : begin
                B_SBSY <= 1'b1;
                incr <= (AD_SEL & ~rst) ? 1'b1 : 1'b0;
                S_DOUT <= MEM_SPACE[MEM_ADDRESS];
                B_ACK <= (count != 2) ? 1'b1 : 1'b0;
                rst <= (count == 1) ? 1'b1 : 1'b0;
                state <= (count == 2) ? IDLE : ACKNWR;
                S_DVALID <= (count == 2) ? 1'b1 : 1'b0;
            end
            READ : begin
                B_SBSY <= 1'b1;
                incr1 <= (AD_SEL & ~rst1) ? 1'b1 : 1'b0;
                rst1 <= (count1 == 6) ? 1'b1 : 1'b0;
                state <= (count1 == 7) ? IDLE : READ;
                B_BUS_IN <= MEM_SPACE[MEM_ADDRESS][count1];
            end
        endcase
    end
end


endmodule