


# HCI commands and events
## contral  & baseband commands
1. Set Event Mask command: 控制HCI为主机生成哪些事件，1表示该事件被启用，其中 LE Meta event 控制的是所有的 LE 事件的启用。
2. Reset command: 重置控制器，对于BR/EDR来说就是LM，对于LE来说就是LL，不影响TL，控制器会进入待机模式。在收到命令完成事件之前，不会再发送任何命令。
3. Read Local Supported Commands command: 会返回status + Supported_Commands（每个HCI命令的比特码，1表示支持该命令）
4. Read Local Supported Features command: BR/EDR支持的列表
- 

## Information paramaters
5. Read Buffer Size command:
	- ACL_Data_Packet_Length: 确定ACL数据包中包含的L2CAP段的大小
	- Synchronous_Data_Packet_Length: 确定HCI同步数据包的最大大小
	- total_Num_ACL_Data_Packets: 可以存储在控制器的数据缓冲区中的HCI ACL数据包的总数。
	- total_Num_Synchronous_Data_Packets: 可以存储在控制器的数据缓冲区中的HCI 同步数据包的总数。
	- 如果控制器不支持HCI上的SCO或eSCO，则应将total_Num_Synchronous_Data_Packets设置为零，在这种情况下，主机应忽略Synchronous_DData_Packet_Length参数。
6. Read BD_ADDR command: 对BR/EDR来说是读取蓝牙控制器地址，对于LE来说是读取公共设备地址。

## events
1. Command complete event: 主机发出请求后向主机传数据，或者主机发出一个命令后向主机传参数。
	- Num_HCI_Command_Packets = 0：不希望主机发数据了，如果不是0，就表示后面发送给主机的数据大小。
	- Command_Opcode = 0 && Num_HCI_Command_Packets != 0：告诉主机，控制器已经准备好了，可以进行通信，或者重启。
	- Command_Opcode: 表示产生这个回复的操作码，需要根据这个操作码确定后面数据应该如何解析
	- Return_Paramaters: 控制器返回的数据，比如Command_Opcode = 0x0002，那么Return_Paramaters就应该按1oct(status)+16oct(support_commands)进行解析

## LE Controller commands
1. LE Set Event Mask command: 控制HCI为主机生成哪些LE事件，这里有任意一位设置了都要将前面的 Event_Mask 中的 LE Meta event 置为1
2. LE Read Buffer Size command: 以下数据长度不包括数据包头部
	- 读取从主机发送到控制器的ACL数据包和同步数据包的数据部分的最大大小以及数据包的总数。如果主机希望发送给控制器的数据包大于这个size，就需要把数据包分段发送（数据包括：HCI ISO中的可选字段）。
	- 如果控制器支持ISO，还要返回ISO数据包的长度（确定ISO数据包中SDU段的大小）和总数。
	- LE_ACL_Data_Packet_Length返回参数应用于确定ACL数据包中包含的L2CAP PDU段的最大大小
	- total_Num_LE_ACL_Data_Packets返回参数包含可以存储在控制器的数据缓冲区中的HCI ACL数据包的总数
3. LE Read Local Supported Features command: 读取支持的 LE 功能
4. LE Set Random Address command: 主机要求控制器生成一个随机地址，必须在广播/扫描/初始化之前生效。对于扩展广播命令来说，只要你敢想扫描和初始化，还需要专门的命令设置广播地址。


22. LE Encrypt command: 主机要求控制器通过一个key去加密128bit的plaintext_data
23. LE Rand command: 主机要求控制器产生一个8字节的随机数