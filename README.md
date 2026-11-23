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

    %% External Inputs
    CLK([System Clock])
    RST([Reset])
    START([Start])
    DIN([Data In 7:0])

    %% SPI MASTER
    subgraph MASTER["SPI MASTER"]
        direction TB

        FSM["FSM Controller"]
        DIV["Clock Divider"]
        MTX["TX Shift Register"]
        MRX["RX Shift Register"]

        FSM --> DIV
        FSM --> MTX
        FSM --> MRX
    end

    %% SPI SLAVE
    subgraph SLAVE["SPI SLAVE"]
        direction TB

        CTRL["Control Logic"]
        STX["TX Shift Register"]
        SRX["RX Shift Register"]

        CTRL --> STX
        CTRL --> SRX
    end

    %% External Connections
    CLK --> FSM
    RST --> FSM
    START --> FSM
    DIN --> MTX

    MRX --> DOUT([Data Out 7:0])
    FSM --> DONE([Done])

    %% SPI Communication
    MTX -->|"MOSI"| SRX
    STX -->|"MISO"| MRX
    DIV -->|"SCLK"| CTRL
    FSM -->|"SS_n (Active Low)"| CTRL

    %% Slave Data Interface
    SDIN([Slave Data In 7:0]) --> STX
    CTRL --> SDOUT([Slave Data Out 7:0])

    %% Styling
    classDef master fill:#1565C0,color:#FFFFFF,stroke:#0D47A1,stroke-width:2px;
    classDef slave fill:#263238,color:#FFFFFF,stroke:#102027,stroke-width:2px;
    classDef external fill:#E3F2FD,color:#102A43,stroke:#1565C0,stroke-width:1.5px;

    class FSM,DIV,MTX,MRX master;
    class CTRL,STX,SRX slave;
    class CLK,RST,START,DIN,DOUT,DONE,SDIN,SDOUT external;
```

