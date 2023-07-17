# Connection
- UART3_TXD <--> P200 <--> B11
- UART3_RXD <--> P201 <--> A11
- UART3_RTS <--> P202 <--> C11
- UART3_CTS <--> P203 <--> B10
- UART2_TXD <--> P104 <--> B8
- UART2_RXD <--> P105 <--> C8
- UART2_RTS <--> P106 <--> E6
- UART2_CTS <--> P107 <--> E5
- UART1_TXD <--> P108 <--> G7
- UART1_RXD <--> P109 <--> G6
- UART1_RTS <--> P110 <--> L7
- UART1_CTS <--> P111 <--> J7
- UART0_TXD <--> P204 <--> C10
- UART0_RXD <--> P205 <--> J9
- UART0_RTS <--> P206 <--> K9
- UART0_CTS <--> P207 <--> L9

# How to get the transfer time of UART?

- Open UART
```
p_uart->p_api->open(p_uart->p_ctrl, p_uart->p_cfg);
```
- Reset the send buffer and receive buffer
- 


_ERBFI_ : Enable Received Data Available Interrupt. This is used to enable/disable the generation of Received Data Available Interrupt and the Character Timeout Interrupt 'if in FIFO mode and FIFO's enabled'. These are the second highest priority interrupts.

_ETBET_ : Enable Transmit Holding Register Empty Interrupt. This is used to enable/disable the generation of Transmitter Holding Register Empty Interrupt. This is the third highest priority interrupt. (Used in transmit)

_ELSI_ : Enable Receiver Line Status Interrupt. This is used to enable/disable the generation of Receiver Line Status Interrupt. This is the highest priority interrupt.

_PTIME_ : Programmable THRE Interrupt Mode Enable. Writeable only when THRE_MODE_USER == Enabled, always readable. This is used to enable/disable the generation of THRE Interrupt. (Used in transmit)








































