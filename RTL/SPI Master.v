//SPI MASTER CODE
`timescale 1ns / 1ps

module spi_master (
    input wire clk,
    input wire rst,
    input wire miso,
    input wire start_tx,
    input wire [7:0] data_in,
    input wire CPOL,
    input wire CPHA,
    input wire msb_first,
    output reg mosi,
    output reg sclk,
    output reg cs,
    output reg tx_done,
    output reg [7:0] rx_data,
    output reg rx_valid
);

    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [7:0] slave_data;
    reg [2:0] bit_count;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            shift_reg <= 8'h00;
            slave_data <= 8'h00;
            bit_count <= 3'd0;
            mosi <= 1'b0;
            sclk <= CPOL;
            cs <= 1'b1;
            tx_done <= 1'b0;
            rx_data <= 8'h00;
            rx_valid <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx_done <= 1'b0;
                    rx_valid <= 1'b0;
                    sclk <= CPOL;
                    cs <= 1'b1;
                    if (start_tx) begin
                        shift_reg <= data_in;
                        bit_count <= 3'd7;
                        state <= LOAD;
                    end
                end

                LOAD: begin
                    cs <= 1'b0;
                    if (msb_first)
                        mosi <= shift_reg[7];
                    else
                        mosi <= shift_reg[0];
                    state <= TRANSFER;
                end

                TRANSFER: begin
                    sclk <= ~sclk;
                    if (sclk == ~CPOL) begin
                        // Sample MISO
                        if (msb_first)
                            slave_data <= {slave_data[6:0], miso};
                        else
                            slave_data <= {miso, slave_data[7:1]};

                        // Shift MOSI
                        if (msb_first) begin
                            shift_reg <= {shift_reg[6:0], 1'b0};
                            mosi <= shift_reg[6];
                        end else begin
                            shift_reg <= {1'b0, shift_reg[7:1]};
                            mosi <= shift_reg[1];
                        end

                        if (bit_count == 0) begin
                            state <= DONE;
                        end else begin
                            bit_count <= bit_count - 1;
                        end
                    end
                end

                DONE: begin
                    cs <= 1'b1;
                    sclk <= CPOL;
                    rx_data <= slave_data;
                    rx_valid <= 1'b1;
                    tx_done <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule




