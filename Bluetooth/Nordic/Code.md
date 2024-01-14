## UART_peripheral
1. 首先，定义了一个静态的FIFO队列（`rx_queue`）用于接收来自控制器的事件和数据。
    
2. 调用`bt_enable_raw(&rx_queue)`启用原始接口，这将打开HCI驱动程序，允许与控制器进行通信。
	1. 首先，获取全局变量`bt_dev.drv`，该变量是一个指向`struct bt_hci_driver`类型的指针，表示蓝牙设备的HCI驱动程序。
    
	2. 将函数参数`rx_queue`赋值给全局变量`raw_rx`，这个变量用于接收来自蓝牙设备的原始数据。
	    
	3. 检查是否注册了HCI驱动程序。如果没有注册，会输出错误日志并返回错误码`-ENODEV`，表示没有找到HCI驱动程序。
	    
	4. 调用`drv->open()`，这个函数是HCI驱动程序中的一个接口，用于打开驱动程序并初始化蓝牙设备。如果打开失败，会输出错误日志并返回错误码。
	    
	5. 如果成功打开驱动程序，会输出信息日志表示蓝牙已在原始模式下启用，并返回成功的状态码0。
    
3. 如果配置了`CONFIG_BT_WAIT_NOP`，则发送一个带有NOP（No Operation）命令的Command Complete事件。这个命令用于检查控制器是否处于可用状态。
	1. `.h4`：一个8位的无符号整数，表示H4事件类型。在这里，它被设置为`H4_EVT`，可能是一个预定义的常量。H4事件是指蓝牙协议栈中的一种事件类型，它是指在蓝牙设备和主机之间传输数据时使用的一种数据帧格式。H4事件包含了一个8位的无符号整数，用于表示事件类型，以及一个可变长度的数据负载，用于传输数据。H4事件通常用于传输ACL数据（Asynchronous Connection-Less Data）和SCO数据（Synchronous Connection-Oriented Data）。在蓝牙协议栈中，H4事件通常是由HCI层（Host Controller Interface）和L2CAP层（Logical Link Control and Adaptation Protocol）使用的。HCI层使用H4事件来传输命令和事件，而L2CAP层使用H4事件来传输数据。具体来说，HCI层会将命令和事件封装成H4事件格式，然后通过蓝牙控制器发送给蓝牙设备。而L2CAP层会将数据封装成H4事件格式，然后通过HCI层发送给蓝牙设备。
	    
	2. `.hdr`：一个`struct bt_hci_evt_hdr`类型的结构体，表示蓝牙事件的头部信息。它包含两个成员：
	    - `.evt`：一个8位的无符号整数，表示蓝牙事件类型。在这里，它被设置为`BT_HCI_EVT_CMD_COMPLETE`，表示命令完成事件。
	    - `.len`：一个8位的无符号整数，表示事件数据的长度。在这里，它被设置为`sizeof(struct bt_hci_evt_cmd_complete)`，表示命令完成事件数据的长度。

	3. `.cc`：一个`struct bt_hci_evt_cmd_complete`类型的结构体，表示命令完成事件的具体信息。它包含两个成员：
	    
	    - `.ncmd`：一个8位的无符号整数，表示命令的数量。在这里，它被设置为1，表示只有一个命令。
	    - `.opcode`：一个16位的无符号整数，表示命令的操作码。在这里，它被设置为`sys_cpu_to_le16(BT_OP_NOP)`，表示一个NOP（No Operation）命令。
	    如果启用了用户空间支持，那么会通过`z_syscall_trap()`函数判断当前是否处于系统调用陷阱（syscall trap）中。如果是，那么会通过`arch_syscall_invoke2()`函数将参数和系统调用号传递给内核，然后直接返回。这里的`K_SYSCALL_UART_POLL_OUT`是一个系统调用号，用于表示向UART设备发送一个字节的数据。

		如果没有启用用户空间支持，或者当前不处于系统调用陷阱中，那么会执行一个内存屏障（memory barrier）指令`compiler_barrier()`，以确保内存操作的顺序和可见性。然后调用`z_impl_uart_poll_out()`函数，实现向UART设备发送一个字节的数据。
4. 创建一个名为`tx_thread_data`的线程，并将其与`tx_thread`函数关联。这个线程用于向控制器发送命令和数据。
	1. 声明一个指向`struct net_buf`类型的指针变量`buf`，用于存储从发送队列中获取的数据缓冲区。
	2. 调用`net_buf_get(&tx_queue, K_FOREVER)`函数从发送队列中获取一个数据缓冲区，并将其赋值给`buf`变量。这里的`K_FOREVER`表示如果发送队列为空，线程将一直等待直到有可用的数据缓冲区。
	3. 调用`bt_send(buf)`函数将获取到的数据缓冲区传递给蓝牙协议栈进行发送。返回值`err`表示发送操作的结果。
	4. 如果发送操作返回错误（`err`非零），则通过`LOG_ERR()`函数记录错误信息，并调用`net_buf_unref(buf)`函数释放数据缓冲区的引用计数。
	5. 调用`k_yield()`函数，将CPU的执行权让给其他线程，以便它们有机会运行。这样做是为了避免在发送队列中不断有新数据到来时，当前线程一直占用CPU资源。
    
5. 进入一个无限循环，不断从`rx_queue`中获取网络缓冲区（`struct net_buf *buf`），然后调用`h4_send(buf)`将缓冲区中的数据发送给控制器。
	1. 调用`k_fifo_put()`函数将数据缓冲区`buf`放入FIFO队列`fifo`中。`k_fifo_put()`函数是Zephyr操作系统提供的一个API，用于将数据放入FIFO队列中。它会将数据缓冲区添加到队列的尾部，并更新队列的状态。


# bt_send
调用`bt_monitor_send()`函数将数据缓冲区的内容发送给蓝牙监视器。`bt_monitor_send()`函数是Zephyr操作系统提供的一个API，用于将数据发送给蓝牙监视器。蓝牙监视器是一种用于监视蓝牙通信的工具，可以帮助开发人员调试蓝牙应用程序。

接下来，如果启用了TinyCrypt ECC（椭圆曲线加密）功能，将调用`bt_hci_ecc_send()`函数发送数据缓冲区。TinyCrypt ECC是一种轻量级的加密库，用于在蓝牙通信中进行加密和解密操作。`bt_hci_ecc_send()`函数是Zephyr操作系统提供的一个API，用于使用TinyCrypt ECC发送数据缓冲区。

最后，如果没有启用TinyCrypt ECC功能，则调用`bt_dev.drv->send(buf)`函数将数据缓冲区发送给蓝牙设备。`bt_dev.drv`表示蓝牙设备的驱动程序，它是在系统初始化时注册的。`bt_dev.drv->send(buf)`函数是蓝牙设备驱动程序提供的一个API，用于将数据缓冲区发送给蓝牙设备。