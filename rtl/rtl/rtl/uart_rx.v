`timescale 1ns / 1ps

module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       rx,

    output reg [7:0]  rx_data,
    output reg        rx_done
);

    localparam IDLE  = 2'b00;
    localparam DATA  = 2'b01;
    localparam STOP  = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state     <= IDLE;
            bit_index <= 3'd0;
            data_reg  <= 8'd0;
            rx_data   <= 8'd0;
            rx_done   <= 1'b0;
        end
        else
        begin
            // Default: rx_done is a one-clock pulse
            rx_done <= 1'b0;

            case (state)

                //----------------------------------
                // Wait for Start Bit
                //----------------------------------
                IDLE:
                begin
                    if (rx == 1'b0)
                    begin
                        bit_index <= 3'd0;
                        state <= DATA;
                    end
                end

                //----------------------------------
                // Receive 8 Data Bits
                //----------------------------------
                DATA:
                begin
                    if (baud_tick)
                    begin
                        data_reg[bit_index] <= rx;

                        if (bit_index == 3'd7)
                            state <= STOP;
                        else
                            bit_index <= bit_index + 1'b1;
                    end
                end

                //----------------------------------
                // Stop Bit
                //----------------------------------
                STOP:
                begin
                    if (baud_tick)
                    begin
                        if (rx == 1'b1)
                        begin
                            rx_data <= data_reg;
                            rx_done <= 1'b1;
                        end

                        state <= IDLE;
                    end
                end

                default:
                    state <= IDLE;

            endcase
        end
    end

endmodule
