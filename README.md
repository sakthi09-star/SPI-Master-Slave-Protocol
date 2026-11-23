# SPI-Master-Slave-Protocol
SPI Master-Slave in Verilog | 4 Modes, 8-bit Full-Duplex | RTL Design for FPGA

# SPI Master-Slave Logic in Verilog

Serial Peripheral Interface (SPI) Master and Slave implementation in Verilog.
Full-duplex, 8-bit data transfer, MSB first.

## Features
- 4 SPI Modes - Mode 0, 1, 2, 3 (CPOL / CPHA configurable)
- 8-bit data transfer, MSB first
- Configurable clock divider for SCLK generation
- Full-duplex transfer - Master and Slave transmit simultaneously
- Single Slave Select (SS) - easily extendable to multi-slave
- Synthesizable RTL - Simulation verified

## Block Diagram

## Block Diagram

```mermaid
flowchart LR
    subgraph MASTER["SPI MASTER"]
        FSM[FSM Controller]
        DIV[Clock Divider]
        TXM[TX Shift Register]
        RXM[RX Shift Register]
    end

    subgraph SLAVE["SPI SLAVE"]
        TXS[TX Shift Register]
        RXS[RX Shift Register]
        CTRL[Control Logic]
    end

    CLK[System Clock] --> DIV
    RST[Reset] --> FSM
    START[Start] --> FSM
    DIN_M[Data In] --> TXM
    TXM -->|MOSI| RXS
    TXS -->|MISO| RXM
    DIV -->|SCLK| CTRL
    FSM -->|SS_n| CTRL
    RXM --> DOUT_M[Data Out]
    RXS --> DOUT_S[Data Out]
    FSM --> DONE[Done]

 
