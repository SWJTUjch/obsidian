# General description
蓝牙分为Basic Rate (BR) and Low Energy (LE)，其中BR中又包含Enhanced Data Rate (EDR)。
- BR传输速率为721.2kb/s，EDR传输速率为2.1Mb/s。
- LE比BR/EDR有更低的电流消耗、更低的复杂性和更低的成本，但速率和占空比也更低，物理层数据速率为2Mb/s。
- 蓝牙核心系统有一个主机和一个或更多的控制器
	- 主机是在非核心文件之下，主机控制器接口（HCI）之上的部分
	- 控制器是HCI之下的逻辑实体
- 蓝牙核心只有一个控制器，可以是：
	- 无线、基带、链路管理和可选的HCI的BR/EDR控制器
	- LE物理层、链路层和可选的HCI的LE控制器
	- 将上述两个BR/EDR和LE集成到一起的单个控制器

## BR/EDR




































