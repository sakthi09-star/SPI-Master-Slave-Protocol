`timescale 1ns / 1ps

module tb_spi;

    reg clk;
    reg rst;
    reg start_tx;
    reg [7:0] master_data;
    reg [7:0] slave_tx_data;
    reg CPOL;
    reg CPHA;
    reg msb_first;

    wire mosi;
    wire miso;
    wire sclk;
    wire cs;
    wire tx_done;
    wire [7:0] master_rx_data;
    wire master_rx_valid;
    wire [7:0] slave_rx_data;
    wire slave_rx_valid;

    spi_master dut_master (
        .clk(clk),
        .rst(rst),
        .miso(miso),
        .start_tx(start_tx),
        .data_in(master_data),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .msb_first(msb_first),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .tx_done(tx_done),
        .rx_data(master_rx_data),
        .rx_valid(master_rx_valid)
    );

    spi_slave dut_slave (
        .sclk(sclk),
        .cs(cs),
        .mosi(mosi),
        .rst(rst),
        .tx_data(slave_tx_data),
        .msb_first(msb_first),
        .miso(miso),
        .rx_data(slave_rx_data),
        .rx_valid(slave_rx_valid)
    );

    // 100 MHz Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        start_tx = 0;
        CPOL = 0;
        CPHA = 0;
        msb_first = 1;
        master_data = 8'hA5;
        slave_tx_data = 8'h3C;

        #20 rst = 1;
        #30 start_tx = 1;
        #10 start_tx = 0;

        wait(tx_done);
        #10;
        $display("Master sent A5, Master received =%h", master_rx_data);
        $display("Slave received=%h", slave_rx_data);

        if (master_rx_data == 8'h3C && slave_rx_data == 8'hA5)
            $display("PASS: SPI Loopback Successful");
        else
            $display("FAIL");

        $finish;
    end

endmodule
