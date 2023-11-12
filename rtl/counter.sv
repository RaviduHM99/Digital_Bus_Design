module counter #(
    parameter WIDTH = 8
) (
    input logic rst,
    input logic clk,
    input logic incr,
    output logic [WIDTH-1:0] count
);
    reg [WIDTH-1:0] COUNTER;

    always @(posedge CLK) begin
        if (rst) COUNTER <= 0;
        else COUNTER <= (incr) ? COUNTER + 'b1 : COUNTER;
    end

    assign count = COUNTER;
endmodule