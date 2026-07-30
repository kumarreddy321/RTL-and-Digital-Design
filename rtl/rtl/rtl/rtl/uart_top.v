`timescale 1ns / 1ps

module uart_top #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst,

    // Transmitter Interface
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    // External RX Pin
    input  wire       rx,

    // UART Outputs
    output wire       tx,
    output wire       busy,
    output wire [7:0] rx_data,
    output wire       rx_done
);

    // Internal baud tick
    wire baud_tick;

    //--------------------------------------------------
    // Baud Rate Generator
    //--------------------------------------------------
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_generator (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    //--------------------------------------------------
    // UART Transmitter
    //--------------------------------------------------
    uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .busy(busy)
    );

    //--------------------------------------------------
    // UART Receiver
    //--------------------------------------------------
    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule
