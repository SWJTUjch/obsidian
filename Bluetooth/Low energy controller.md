# 待机状态
## 初始化设置
- 主机处于接收数据的状态，等待控制器发送数据，控制器发送一个重置命令，开始进行初始化设置
- 主机先将控制器reset到一个确定的状态，然后去读取控制器所支持的功能。
- 接下来设置 event mask 和 LE event mask，读 buffer 和 LE buffer的大小以检查应用于数据流的 buffer。
- 还需要读取所支持的LE的特性并选择希望使用的特性。
- 最后读取设备的地址。
![initial setup](Low_energy_controller/initial_setup.jpg)
## 设置随机设备地址
- 蓝牙设备有两个地址，一个是 public address，一个是 random address
- 需要由主机发起一个LE Rand的命令产生8字节的随机数
- 加密
- 设置随机地址
![initial setup](Low_energy_controller/random_device_address.jpg)
## 筛选接受列表






















































