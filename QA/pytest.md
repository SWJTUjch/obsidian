# pytest 基本规则

## pytest测试用例规则

1. 模块名必须以`test_`开头或`_test`结尾
2. 测试类必须以`Test`开头且不能有`init`方法
3. 测试方法必须以`test`开头

## pytest测试用例运行方式
1. 主函数模式
   1) 运行所有：pytest.main()
   2) 指定模块/目录：如果指定模块为package包下所有文件，则传package路径即可】
   ```python
   pytest.main(['-s', '指定模块名.py'])
	```
   3) 通过nodeid指定用例运行：nodeid由模块名、分隔符、类名、方法名、函数名组成。例如：
```python
	pytest.main(['-s', '路径/指定模块名.py::类名::方法名'])
```
2. 命令行模式
    1) 运行所有：pytest
    2) 指定模块/目录：pytest -s 指定模块名.py【注：如果指定模块为package包下所有文件，则传package路径即可】




## 参数
- `-s`输出用例调试信息包括`print`的内容
- `-v`除了输出调试信息，还会显示类名用例方法名
- `-n`支持多线程或分布式运行；例：
```python
	pytest.main(['-vs', 'testcase/', '-n=2'])
```









