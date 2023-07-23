


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












65. LE Meta event
	- LE Connection Complete event: 
		- 如果创建成功，返回给两边的主机，否则，只返回给发起创建连接的主机
		- 创建连接后，控制器应分配connection_Handle，并在这种情况下将其传递给主机

## LE Controller commands
1. LE Set Event Mask command: 控制HCI为主机生成哪些LE事件，这里有任意一位设置了都要将前面的 Event_Mask 中的 LE Meta event 置为1
2. LE Read Buffer Size command: 以下数据长度不包括数据包头部
	- 读取从主机发送到控制器的ACL数据包和同步数据包的数据部分的最大大小以及数据包的总数。如果主机希望发送给控制器的数据包大于这个size，就需要把数据包分段发送（数据包括：HCI ISO中的可选字段）。
	- 如果控制器支持ISO，还要返回ISO数据包的长度（确定ISO数据包中SDU段的大小）和总数。
	- LE_ACL_Data_Packet_Length返回参数应用于确定ACL数据包中包含的L2CAP PDU段的最大大小
	- total_Num_LE_ACL_Data_Packets返回参数包含可以存储在控制器的数据缓冲区中的HCI ACL数据包的总数
3. LE Read Local Supported Features command: 读取支持的 LE 功能
4. LE Set Random Address command: 主机要求控制器生成一个随机地址，必须在广播/扫描/初始化之前生效。对于扩展广播命令来说，只要你敢想扫描和初始化，还需要专门的命令设置广播地址。
5. LE Set Advertising Parameters command: 
	- 设置最大/最小扫描间隔
	- 对于高占空比的广播，会忽略最大/最小间隔。
	- 确定包的类型
	- 广播数据包中的地址类型
	- 地址和地址类型用于在解析列表中定位对应的本地IRK；该IRK用于生成广播中使用的自己的地址。
	- 如果Own_Address_Type时0x02或0x03，则Peer_Address_Type应该设置成对应的0x00或0x01.
	- Advertising_Channel_Map指示可用的信道
	- Advertising_Filter_Policy在设置了定向广播时会被忽略
	- 控制器在广播时，主机不能发出这个命令
6. LE Read Advertising Physical Channel Tx Power command: 读取用于LE广播物理信道分组的发射功率电平。
7. LE Set Advertising Data command: 设置数据字段的长度，以及在广播阶段发送重要的数据包。如果启用了广播，那么下次广播就使用新设置，如果未启用，则先保存，在启用后设置。如果正在广播，则可以使用新的或旧数据。
8. LE Set Scan Response Data command: 用于设置具有数据字段的扫描数据包中使用的数据。设置时机同上。
9. LE Set Advertising Enable command: 启用或停止广播，管理前面设置的时间控制定时器。
	- 启用之后，控制器应该持续广播并且在收到该命令中参数为0x00时（使用广播建立连接或者高占空比定向广播超时），禁用广播。
	- 当广播类型设置为0x00 0x01 0x04，且禁用广播时，可能会存在竞争条件，创建连接前可能不会停止广播。

12. 


14. LE Read Filter Accept List Size command: 由于控制器中存储过滤列表的内存可以被用于其他用途，所以需要每次询问。
15. LE Clear Filter Accept List command: 清空过滤列表，以下情况时不能清空：
	-  广播/扫描过滤策略使用了该列表并且已经开始
	- 初始化过滤策略使用该列表并且创建和扩展创建连接被挂起
16. LE Add Device To Filter Accept List command: 向列表中添加单个设备，以上场景中不能使用。
	- 空间已满时会返回错误
	- 已存在则不会重复添加并返回success
	- Address_Type为0xFF时表示匿名广播



22. LE Encrypt command: 主机要求控制器通过一个key去加密128bit的plaintext_data
23. LE Rand command: 主机要求控制器产生一个8字节的随机数



34. LE Read Suggested Default Data Length command: 
35. LE Write Suggested Default Data Length command: 为控制器指定负载的最大传输数量和为新连接的LL数据PDU分组的最大传输时间






38. LE Add Device To Resolving List command
	- 添加的设备应设置为网络隐私模式。
	- 如果添加的设备已存在，则返回错误码
	- 




40. LE Clear Resolving List command: 该命令可以在地址解析失效时随时使用。
41. LE Read Resolving List Size command: 由于控制器中存储该列表的内存可以被用于其他用途，所以需要每次询问。



53. LE Set Extended Advertising Parameters command: 











70. LE Add Device To Periodic Advertiser List command: 用于增加一个项目，包括设备地址和SID（set ID），会立即生效。


72. LE Clear Periodic Advertiser List command: 从列表中删除所有项，
73. LE Read Periodic Advertiser List Size command: 由于控制器中存储该列表的内存可以被用于其他用途，所以需要每次询问。
74. 