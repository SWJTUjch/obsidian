


# HCI commands and events
## contral  & baseband commands
1. Set Event Mask command: 
2. Reset command: 重置控制器，对于BR/EDR来说就是LM，对于LE来说就是LL，不影响TL，控制器会进入待机模式。在收到命令完成事件之前，不会再发送任何命令。
3. Read Local Supported Commands command: 会返回status + Supported_Commands（每个HCI命令的比特码，1表示支持该命令）
4. Read Local Supported Features command: BR/EDR支持的列表
- 

## Information paramaters
- Read Buffer Size command:
- Read BD_ADDR command:

## events
- Command complete event: 主机发出请求后向主机传数据，或者主机发出一个命令后向主机传参数。
	- Num_HCI_Command_Packets = 0：不希望主机发数据了，如果不是0，就表示后面发送给主机的数据大小。
	- Command_Opcode = 0 && Num_HCI_Command_Packets != 0：告诉主机，控制器已经准备好了，可以进行通信，或者重启。
	- Command_Opcode: 表示产生这个回复的操作码，需要根据这个操作码确定后面数据应该如何解析
	- Return_Paramaters: 控制器返回的数据，比如Command_Opcode = 0x0002，那么Return_Paramaters就应该按1oct(status)+16oct(support_commands)进行解析

## LE Controller commands
- LE Read Buffer Size command
- LE Read Local Supported Features command
- LE Set Event Mask command