`timescale 1ns / 1ps

module baud_gen #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);

    // Number of clock cycles per baud period
    localparam integer COUNT_MAX = CLK_FREQ / BAUD_RATE;

    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count     <= 0;
            baud_tick <= 1'b0;
        end
        else begin
            if (count == COUNT_MAX - 1) begin
                count     <= 0;
                baud_tick <= 1'b1;
            end
            else begin
                count     <= count + 1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule
