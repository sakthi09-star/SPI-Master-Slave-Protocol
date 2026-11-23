//SPI SLAVE CODE
`timescale 1ns / 1ps

module spi_slave (
    input wire sclk,
    input wire cs,
    input wire mosi,
    input wire rst,
    input wire [7:0] tx_data,
    input wire msb_first,
    output wire miso,
    output reg [7:0] rx_data,
    output reg rx_valid
);

    reg [7:0] shift_tx;
    reg [7:0] shift_rx;
    reg [2:0] bit_count;

    // MISO is always MSB of TX shift register
    assign miso = shift_tx[7];

    // Load TX data when CS goes low
    always @(negedge cs or negedge rst) begin
        if (!rst) begin
            shift_tx <= 8'h00;
            shift_rx <= 8'h00;
            bit_count <= 3'd0;
            rx_data <= 8'h00;
            rx_valid <= 1'b0;
        end else begin
            shift_tx <= tx_data;
            shift_rx <= 8'h00;
            bit_count <= 3'd0;
            rx_valid <= 1'b0;
        end
    end

    // Sample MOSI on rising edge of SCLK
    always @(posedge sclk) begin
        if (!cs) begin
            if (msb_first)
                shift_rx <= {shift_rx[6:0], mosi};
            else
                shift_rx <= {mosi, shift_rx[7:1]};

            bit_count <= bit_count + 1;

            if (bit_count == 3'd7) begin
                if (msb_first)
                    rx_data <= {shift_rx[6:0], mosi};
                else
                    rx_data <= {mosi, shift_rx[7:1]};
                rx_valid <= 1'b1;
            end
        end
    end

    // Shift MISO on falling edge of SCLK
    always @(negedge sclk) begin
        if (!cs) begin
            if (msb_first)
                shift_tx <= {shift_tx[6:0], 1'b0};
            else
                shift_tx <= {1'b0, shift_tx[7:1]};
        end
    end

endmodule
