# UART Design (Verilog)

A simple 8-N-1 UART transmitter and receiver with parameterized clocks-per-bit.
The receiver samples near the middle of each bit. The testbench loops the TX
output back to RX and checks a transmitted byte.

## Run
```bash
iverilog -g2012 -o sim.out rtl/uart_tx.v rtl/uart_rx.v tb/tb_uart.v
vvp sim.out
```
