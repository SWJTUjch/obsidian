# 基础知识
## QSPI

QSPI代表Quad-SPI（四线串行外部存储器接口），而XIP代表eXecute In Place（就地执行）。QSPI的XIP是一种技术，它允许直接从外部存储器中执行代码，而无需将代码加载到内部存储器中。

传统上，执行程序需要将代码从外部存储器（例如闪存）加载到内部RAM（随机存储器）中，然后再执行。这样的过程需要较长的时间和较多的系统资源。

而使用QSPI的XIP技术，处理器可以直接从外部存储器中执行代码，而无需复制到内部存储器中。这样可以显著提高系统性能和效率，减少对内部存储器的需求，并节省功耗和成本。

QSPI的XIP适用于需要高性能和快速启动的应用，例如嵌入式系统、物联网设备、汽车电子等。它提供了更快的启动时间、更高的可用性和更低的功耗消耗，使系统更加高效和可靠。


## Generic Access Profile （GAP）
通用访问配置文件 (GAP) 块代表所有蓝牙设备通用的基本功能，例如传输、协议和应用配置文件使用的模式和访问过程。 GAP服务包括设备发现、连接模式、安全、认证、关联模型和服务发现。






# test api
```C
.open = RM_BLE_ABS_Open,
.close = RM_BLE_ABS_Close,
.reset = RM_BLE_ABS_Reset,
.startLegacyAdvertising = RM_BLE_ABS_StartLegacyAdvertising,
.startExtendedAdvertising = RM_BLE_ABS_StartExtendedAdvertising,
.startNonConnectableAdvertising = RM_BLE_ABS_StartNonConnectableAdvertising,
.startPeriodicAdvertising = RM_BLE_ABS_StartPeriodicAdvertising,
.startScanning = RM_BLE_ABS_StartScanning,
.createConnection = RM_BLE_ABS_CreateConnection,
.setLocalPrivacy = RM_BLE_ABS_SetLocalPrivacy,
.startAuthentication = RM_BLE_ABS_StartAuthentication,
.deleteBondInformation = RM_BLE_ABS_DeleteBondInformation,
.importKeyInformation = RM_BLE_ABS_ImportKeyInformation,
.exportKeyInformation = RM_BLE_ABS_ExportKeyInformation,
```

# 程序流程

## 初始化QSPI XIP
## 执行蓝牙程序

- 初始化蓝牙
	- 打开蓝牙
		- 打开蓝牙栈
		- 设置参数
		- 初始化GAP层
		- 设置回调函数
		- 初始化GATT服务端
		- 注册GATT服务的回调函数
		- 初始化GATT客户端
		- 注册GATT客户端的回调函数
		- 设置Vendor Specific
		- 初始化定时器
	- 初始化GATT数据库
	- 初始化GATT服务器
	- 初始化GATT客户端
	- 设置GATT写队列
	- 初始化LED切换服务服务器的API
- 处理蓝牙event

1. 注册LSS（LED Switch Service）回调函数lss_cb
- type是传入的动作类型，从而判断应该进行什么操作，通过p_data.p_param可以得到传输的值。
- 当该参数为00或FF则为常亮或长灭
- 否则就打开blink的标志位
- 主循环中每轮更新一次时间，第一次进入会设置时间，时间减为0，并且设置了blinky的标志，且不是FF，就要获取引脚当前状态并反转状态，然后重新设置时间


## automation
1. How the log record? 
		Windows PC record all of the log and receive logs from Ubuntu PC, while Ubuntu PC record log local and report to Windows PC to avoid the disconnection of socket.
2. Can Ubuntu PC control USBRelay?
3. Download bin and elf depart? Only download bin once.




## cmd
- vs
	- txp
		- set : set conn_hdl <tx_poewr(0-2)>
		- get : get conn_hdl
	- test
		- tx : tx <ch(0-39)> <data_len(0-255)> <payload(0-7)> <phy(1-4)> <tx_power(0-2)> <option(0-3)> <num_of_packet(0-65535)>
		- rx : rx <ch(0-39)> <phy(1-3)>
		- end : end
	- addr 
		- set : set (curr|df) (pub|rnd) addr \[mcu_rst\]
		- get : get (curr|df) (pub|rnd)
	- scheme : scheme <scheme(hex)>
	- rfctrl : rfctrl <power(on|off)> <option(0|1)> <clval(hex)> <slw_clk(hex)> <tx_power(0-2)> <rf_opt(hex)>
	- rand : rand <rand_size(4-16)>
	- scan_ch_map
		- set : set <ch_map(1-7)>
		- get : get
- ble
	- reset : reset
	- close : close
- sys
	- stby : stby (on|off|get)
- l2cap
	- psm : psm (reg|dereg) psm (lwm: reg only)
	- conn : conn (req|rsp|disconn) ...
	- credit : credit send credit
	- data : data send conn_hdl lcid data_len
- gatts
	- get : get attr_hdl _Get char value from local GATT db_
	- set : set attr_hdl values _Set local GATT db char value_
	- notify : notfiy conn_hdl attr_hdl values _Send notification_
	- indicate : indicate conn_hdl attr_hdl values _Send indication_
- gap
	- adv : adv (legacy|ext|non-conn|periodic) (start|stop)  _Start or stop legacy advertising_
	- scan : scan \[ad_type\] \[ad_data\] _Start scanning_
	- conn : conn addr (pub|rnd) _Create connection_
	- disconn : disconn conn_hdl
	- device : device _List connecting devices_
	- sec : security _Pairing_
	- perd : perd (start|stop) _Start or stop periodic advertising_
	- sync : 
	- wl : wl (reg|del|clear) _Register or delete or clear white list_
- 






















