# 通信协议
- Idle时保持为1，传输数据时1bit的0为起始位，可配置5~8位的数据位（LSB--MSB），1bit校验位，1~2bit停止位
- 波特率的计算
![](uart_baudrate.png)
- 高波特率会产生一定的误差
	- 

# CMSIS_5 driver
- CMSIS（Cortex Micro-controller Software Interface Standard) 是ARM定义的软件界面标准




_r_uart_usod.c_

_ERBFI_ : Enable Received Data Available Interrupt. This is used to enable/disable the generation of Received Data Available Interrupt and the Character Timeout Interrupt 'if in FIFO mode and FIFO's enabled'. These are the second highest priority interrupts.

_ETBET_ : Enable Transmit Holding Register Empty Interrupt. This is used to enable/disable the generation of Transmitter Holding Register Empty Interrupt. This is the third highest priority interrupt. (Used in transmit)

_ELSI_ : Enable Receiver Line Status Interrupt. This is used to enable/disable the generation of Receiver Line Status Interrupt. This is the highest priority interrupt.

_PTIME_ : Programmable THRE Interrupt Mode Enable. Writeable only when THRE_MODE_USER == Enabled, always readable. This is used to enable/disable the generation of THRE Interrupt. (Used in transmit)






























