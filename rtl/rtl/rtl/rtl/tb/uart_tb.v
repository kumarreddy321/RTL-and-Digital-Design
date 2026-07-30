`timescale 1ns / 1ps

module uart_tb;

parameter CLK_FREQ  = 50000000;
parameter BAUD_RATE = 9600;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire busy;
wire [7:0] rx_data;
wire rx_done;

// Loopback connection
wire rx;

assign rx = tx;

//-------------------------------------------------
// Instantiate UART Top
//-------------------------------------------------
uart_top #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) dut (

    .clk(clk),
    .rst(rst),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .rx(rx),

    .tx(tx),
    .busy(busy),
    .rx_data(rx_data),
    .rx_done(rx_done)

);

//-------------------------------------------------
// Clock Generation (50 MHz)
//-------------------------------------------------
always #10 clk = ~clk;

//-------------------------------------------------
// Test Sequence
//-------------------------------------------------
initial
begin

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #100;

    rst = 0;

    #100;

    //-------------------------------------------------
    // Send Byte
    //-------------------------------------------------

    tx_data = 8'hA5;

    tx_start = 1;

    #20;

    tx_start = 0;

    //-------------------------------------------------
    // Wait for Reception
    //-------------------------------------------------

    wait(rx_done);

    if(rx_data == 8'hA5)
        $display("-------------------------------------");
    if(rx_data == 8'hA5)
        $display("PASS : Received = %h",rx_data);
    else
        $display("FAIL : Received = %h",rx_data);

    if(rx_data == 8'hA5)
        $display("-------------------------------------");

    #1000;

    $finish;

end

endmodule
