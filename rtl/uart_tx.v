`timescale 1ns / 1ps

module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output reg        tx,
    output reg        busy
);

reg [3:0] bit_index;
reg [7:0] data_reg;

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        busy <= 1'b0;
        bit_index <= 0;
        data_reg <= 8'd0;
    end
    else
    begin

        case(state)

        //---------------------------------------
        // IDLE
        //---------------------------------------
        IDLE:
        begin
            tx <= 1'b1;
            busy <= 1'b0;

            if(tx_start)
            begin
                busy <= 1'b1;
                data_reg <= tx_data;
                bit_index <= 0;
                state <= START;
            end
        end

        //---------------------------------------
        // START BIT
        //---------------------------------------
        START:
        begin
            if(baud_tick)
            begin
                tx <= 1'b0;
                state <= DATA;
            end
        end

        //---------------------------------------
        // DATA BITS
        //---------------------------------------
        DATA:
        begin
            if(baud_tick)
            begin
                tx <= data_reg[bit_index];

                if(bit_index == 7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end
        end

        //---------------------------------------
        // STOP BIT
        //---------------------------------------
        STOP:
        begin
            if(baud_tick)
            begin
                tx <= 1'b1;
                busy <= 1'b0;
                state <= IDLE;
            end
        end

        default:
            state <= IDLE;

        endcase

    end
end

endmodule
