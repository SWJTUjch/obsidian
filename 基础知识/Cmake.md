- macro: 声明一个宏，括号中第一个参数是宏的名字，后面才是宏的参数
```
macro(zephyr_library_named name) 
```
- set: set(A,${B})， 第一个参数写变量名称，第二个参数写变量所指代的内容
```
set(ZEPHYR_CURRENT_LIBRARY ${name})
```
- ${CMAKE_PARENT_LIST_FILE}: 包含当前文件的 CMake 文件的完整路径。比如：/local/workspace/LE_Audio/Bluetooth/FullStack/projects/pegasus_host/CMakeLists.txt
- get_filename_component(变量名 参数 选项)
	- DIRECTORY = 没有文件名的目录
	- NAME      = 没有目录的文件名
	- EXT       = 文件名最长扩展名 (.b.c from d/a.b.c)
	- NAME_WE   = 既没有目录也没有最长扩展名的文件名
	- LAST_EXT  = 文件最后一个扩展名 (.c from d/a.b.c)
	- NAME_WLE  = 既没有目录也没有最后一个扩展名的文件名
	- PATH      = 同DIRECTORY，没有文件名的目录 (use for CMake <= 2.8.11)
	- ABSOLUTE  = 文件的完整路径
	- REALPATH  = 已解析符号链接的现有文件的完整路径



