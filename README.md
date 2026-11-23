# SPI Master-Slave Logic in Verilog

Serial Peripheral Interface (SPI) Master and Slave implementation in Verilog.
Full-duplex, 8-bit data transfer, MSB first.

## Features
- 8-bit data transfer, MSB first (`msb_first`)
- CPOL / CPHA configurable
- Full-duplex transfer - Master and Slave transmit simultaneously
- Single Chip Select (`cs`) - easily extendable to multi-slave
- Synthesizable RTL - Simulation verified

## Block Diagram

```text
                     SPI Master-Slave - Block Diagram


  clk (100 MHz) ───►┌──────────────────────────────┐
                    │         SPI MASTER           │
  rst ─────────────►│  FSM: IDLE -> LOAD ->        │
                    │       TRANSFER -> DONE       │
  start_tx ────────►│                              │
                    │  ┌────────────────────────┐  │         ┌──────────────────────────────┐
  data_in[7:0] ────►│  │ shift_reg [7:0] (TX) │  │  MOSI   │          SPI SLAVE           │
  (8'hA5)           │  └────────────────────────┘  ├────────►│  ┌────────────────────────┐  │
                    │  ┌────────────────────────┐  │         │  │ shift_tx [7:0] (TX)    │  │
  CPOL ────────────►│  │ slave_data [7:0] (RX) │  │  MISO   │  └────────────────────────┘  │
  CPHA ────────────►│  └────────────────────────┘  │◄────────┤  ┌────────────────────────┐  │
  msb_first ───────►│  ┌────────────────────────┐  │         │  │ shift_rx [7:0] (RX)    │  │
                    │  │ bit_count [2:0]        │  │  SCLK   │  └────────────────────────┘  │
                    │  └────────────────────────┘  ├────────►│  ┌────────────────────────┐  │
                    │                              │         │  │ bit_count [2:0]        │  │
  rx_data[7:0] ◄────│                              │  cs     │  └────────────────────────┘  │
  rx_valid ◄────────│                              │────────►│  cs = 0 : selected         │
  tx_done ◄─────────│                              │         │  miso = shift_tx[7]        │
                    └──────────────────────────────┘         └──────────────┬───────────────┘
                                                                            │
                                            tx_data[7:0] (8'h3C) ──────────►│
                                            msb_first ─────────────────────►│
                                            rst ───────────────────────────►│
                                                                            │
                                            rx_data[7:0] ◄───────────────────┘
                                            rx_valid ◄────────────────────────┘

MOSI: Master Out Slave In | MISO: Master In Slave Out | cs: Chip Select (active low)
