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
3. 读取pytest.ini配置文件
	1) 位置：一般放在项目根目录，且名字不能改
	2) 编码：必须是ANSI，可以用notepad++修改编码格式
	3) 作用：可以改变pytest默认的行为（比如你不想用例以test开头，那就来这里改)
	4) 运行规则：不管用主函数还是命令行模式运行，都会读取配置文件。
```python
addopts  #命令行参数
testpaths
python_files
python_classes
python_functions
```






## 参数
- `-s`：输出用例调试信息包括`print`的内容
- `-v`：除了输出调试信息，还会显示类名用例方法名
- `-n`：支持多线程或分布式运行；例：
```python
	pytest.main(['-vs', 'testcase/', '-n=2'])
```
- `--reruns`：失败后重跑，需要安装`pytest-rerunfailures`库，语法：
```python
	pytest.main(['-vs', 'testcase/', '--reruns=2'])
```
- `-x`：只要有一个用例报错，则用例停止。语法：
```python
	pytest.main(['-vs', 'testcase/', '-x'])
```
- `--maxfail`：最多报错后停止。上面-x是一个报错就停止，这个是最多能接受多少个用例报错
- `-k`：根据测试用例的部分字符串指定测试用例
```python
	pytest.main(['-vs', 'testcase/', '-k', '用例名中的字符'])
```

## **pytest执行测试用例的顺序**

默认从上到下。如果不想从上到下执行，则可以通过加标记的方式（需要安装pytest-ordering）：
```python
	@pytest.mark.run(order=n)
```



