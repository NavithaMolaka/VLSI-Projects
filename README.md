# UART Transmitter - RTL to GDSII

### FSM based 8N1 UART TX in Verilog | End-to-End ASIC Flow

**Author:** Molaka Navitha | B.Tech ECE - CBIT Proddatur (2027)

## 🔧 Overview
- Designed 8-bit UART Transmitter with 4-state FSM: IDLE → START → DATA → STOP
- Baud Rate: 9600 configurable
- Protocol: 8N1 (8 data bits, No parity, 1 Stop bit)

## 📁 Files
- `uart_tx.v` - RTL Design
- `uart_tx_tb.v` - Testbench with $dumpfile
- `README.md` - Documentation

## ⚙️ Flow Completed
1.  **RTL Design:** Verilog HDL (FSM)
2.  **Simulation:** Icarus Verilog + GTKWave
