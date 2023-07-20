

# HCI commands and events
## contral  & baseband commands
- Reset command: 重置控制器，对于BR/EDR来说就是LM，对于LE来说就是LL，不影响TL，控制器会进入待机模式。在收到命令完成事件之前，不会zai'fa'song

## events
- Command complete event: 主机发出请求后向主机传数据，或者主机发出一个命令后向主机传参数。
	- Num_HCI_Command_Packets = 0：不希望主机发数据了
	- Command_Opcode = 0 && Num_HCI_Command_Packets != 0：告诉主机，控制器已经准备好了，可以进行通信。或者重启。

## LE Controller commands
- LE 