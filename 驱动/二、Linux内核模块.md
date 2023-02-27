# 概念
内核模块不会被编译进内核，而是在内核需要用到内核模块功能时，才自动加载到内核中。
## 相关操作
- lsmod：查看已加载的所有模块以及所有模块之间的关系，该命令是读取并分析/proc/modules文件。
- insmod：加载模块
- rmmod：卸载模块
- modprobe：加载模块时同时加载该模块所依赖的其他模块
- modprobe -r：卸载安装的模块及其依赖的模块
- modinfo：查询模块信息
# 内核模块程序结构
模块名称就是这个代码编译后的.ko目标文件名
## 模块加载函数
``` c
static int __init func(void)
{
	/*初始化代码*/
}
module_init(func);
```
- 内核加载函数一般以__init标识声明，如果直接编译进入内核，则在连接时会被放在.init.text区段内，因为内核中有这样的宏定义：
```c
#define __init __attribute__((__section__(".init.text")))
```
- 将__init编译进内核时，在.initcall.init中还保存了一份函数指针，内核通过函数指针调用这些函数，初始化完成后释放init区段。
- 内核中可以通过调用request_module(module_name)函数加载其他内核模块
- 返回值是一个不大于0的整数，0表示正确，非0表示初始化出错
- 模块的加载是通过module_init(func)来完成的
- 还可以将数据定义为__initdata，这样数据也会在初始化完成后被释放。
## 模块卸载函数
``` c
static void __exit func(void)
{
	/*初始化代码*/
}
module_exit(func);
```
- 卸载时不返回任何值
## 模块参数
模块参数用于模块内，必须要在代码中设置。
==模块参数的设置==
- 默认参数：在模块内设置，具体形式为先定义，再注册
	- 其中module_parm的参数分别是：参数名，参数类型，参数读写权限
	- 参数类型包括：byte short ushort int uint long ulong charp bool invbool，参数类型注册时和定义时的类型必须要一致
	- 模块可以有参数数组module_parm_array(数组名，数组类型，数组长，参数读写权限)
``` c
static int num = 100;
module_parm(num, int, S_IRUGO);
```
- 装载内核模块时，用户可以通过如下语句进行设置
```Shell session
insmode 模块名 参数名=参数值
```
- 如果内核模块被编译进了内核，无法手动设置时，bootloader可以通过再bootargs里设置：模块名.参数名=值

模块被加载之后，/sys/module目录下会出现以这个模块名命名的目录。可以通过parameters目录查看设置的参数值。








