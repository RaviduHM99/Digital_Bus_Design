`timescale 1ns/1ps

module slave_4K(
    input logic CLK,
    input logic RSTN,

    output logic S_DVALID, 
    output logic [7:0] S_DOUT,

    input logic AD_SEL,
    
    output logic B_ACK,
    input logic B_RW,
    output logic B_SBSY,
    output logic B_BUS_IN,
    input logic B_BUS_OUT
);

    enum logic [2:0] { IDLE, ADDRESS, ACKNAR, WRITE, ACKNWR, READ} state, Adr_state, Ackad_state;

    localparam WIDTH = 4;
    logic rst, incr;
    logic [WIDTH-1:0] count;
    counter #(.WIDTH(WIDTH)) counter (.rst(rst), .CLK(CLK), .incr(incr), .count(count));

    reg [15:0] REG_ADDRESS;
    reg [4095:0][7:0] MEM_SPACE; //2^12
    
    always_comb begin
        Adr_state = (AD_SEL) ? ACKNAR : IDLE;

        unique case (B_RW)
            1'b0 : Ackad_state = READ;
            1'b1 : Ackad_state = WRITE;
        endcase
    end

    //assign S_DOUT = MEM_SPACE[REG_ADDRESS];
    assign S_DOUT = 8'd0;

always_ff @( posedge CLK or negedge RSTN) begin 
    if (!RSTN) begin
        rst <= 1'b1;
        MEM_SPACE <= 'd0;
        REG_ADDRESS <= 'd0;
        B_ACK <= 1'b0;
        B_SBSY <= 1'b0;
        B_BUS_IN <= 1'b0;
        S_DVALID <= 1'b0;
        state <= IDLE;
        incr <= 1'b0;
    end
    else begin
        incr <= (AD_SEL) ? 1'b1 : 1'b0;
        B_ACK <= 1'b0;
        S_DVALID <= 1'b0;
        REG_ADDRESS <= REG_ADDRESS;
        MEM_SPACE <= MEM_SPACE;
        B_BUS_IN <= 1'b0;
        B_SBSY <= 1'b0;

        unique case (state)
            IDLE : begin
                state <= (AD_SEL) ? ADDRESS : IDLE;
                REG_ADDRESS <= 16'd0;
                rst <= 1'b0;
            end
            ADDRESS : begin
                B_SBSY <= 1'b1;
                REG_ADDRESS[count] <= B_BUS_OUT;
                state <= (count != 15) ? ADDRESS : Adr_state;
                rst <= (count == 14) ? 1'b1 : 1'b0;
            end
            ACKNAR : begin
                B_SBSY <= 1'b1;
                B_ACK <= (count != 2) ? 1'b1 : 1'b0;
                rst <= (count == 2) ? 1'b1 : 1'b0;
                state <= (count == 2) ? Ackad_state : ACKNAR; 
            end 
            WRITE : begin
                B_SBSY <= 1'b1;
                MEM_SPACE[REG_ADDRESS[13:2]] <= B_BUS_OUT;
                rst <= (count == 6) ? 1'b1 : 1'b0;
                state <= (count != 7) ? WRITE : ACKNWR;
            end
            ACKNWR : begin
                B_SBSY <= 1'b1;
                B_ACK <= (count != 2) ? 1'b1 : 1'b0;
                rst <= (count == 1) ? 1'b1 : 1'b0;
                state <= (count == 2) ? IDLE : ACKNWR;
                S_DVALID <= (count == 2) ? 1'b1 : 1'b0;
            end
            READ : begin
                B_SBSY <= 1'b1;
                rst <= (count == 6) ? 1'b1 : 1'b0;
                state <= (count == 7) ? IDLE : READ;
                B_BUS_IN <= MEM_SPACE[REG_ADDRESS[13:2]][count];
            end
        endcase
    end
end


endmodule