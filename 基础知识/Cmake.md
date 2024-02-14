- macro: 声明一个宏，括号中第一个参数是宏的名字，后面才是宏的参数
```
macro(zephyr_library_named name) 
```
- set: set(A,${B})， 第一个参数写变量名称，第二个参数写变量所指代的内容
```
set(ZEPHYR_CURRENT_LIBRARY ${name})
```