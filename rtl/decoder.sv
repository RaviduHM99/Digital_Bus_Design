`timescale 1ns/1ps

module decoder(
    input logic rst,
    input logic clk,
    input logic [15:0] HADDR,
    output logic SEL_4K, SEL_2K1, SEL_2K2,
    output logic [1:0] SELR
);

always @(posedge clk or posedge rst) begin
    if (rst == 1) begin
        SEL_4K = 0;
        SEL_2K1 = 0;
        SEL_2K2 = 0;
        SELR = 2'b00;
    end
    else begin
        unique case (HADDR[14:13])
            2'b01: begin
                SEL_4K = 1;
                SEL_2K1 = 0;
                SEL_2K2 = 0;
                SELR = 2'b01;
            end
            2'b10: begin
                SEL_4K = 0;
                SEL_2K1 = 1;
                SEL_2K2 = 0;
                SELR = 2'b10;
            end
            2'b11: begin
                SEL_4K = 0;
                SEL_2K1 = 0;
                SEL_2K2 = 1;
                SELR = 2'b11;
            end
            default: begin
                SEL_4K = 0;
                SEL_2K1 = 0;
                SEL_2K2 = 0;
                SELR = 2'b00;
            end
        endcase
    end
end
    
endmodule