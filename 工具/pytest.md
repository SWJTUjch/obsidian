# pytest 基本规则

## pytest测试用例规则

1. 模块名必须以`test_`开头或`_test`结尾
2. 测试类必须以`Test`开头且不能有`init`方法
3. 测试方法必须以`test`开头
4. 在Test类中，类成员变量在不同的test方法之间是不共享的，每个test方法会有一个私有的instance
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
addopts                             # 命令行参数
testpaths                           # 测试用例路径
python_files                        # 模块名规则
python_classes                      # 类名规则
python_functions                    # 方法名规则
markers                             # 分组执行
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
	pytest.main(['-vs', 'testcase/', '-k', 'MyClass and not method']) # 包含MyClass但不包含method的方法
```
- 获取运行时间超过1s的最慢的10个case
```python
	pytest --durations=10 --durations-min=1.0
```
## pytest的标记
1. 标记pytest执行测试用例的顺序
	默认从上到下。如果不想从上到下执行，则可以通过加标记的方式（需要安装pytest-ordering）：
```python
	@pytest.mark.run(order=n)
```
2. 标记分组
	先在用例里标记，然后-m参数运行即可
```python
@pytest.mark.smoke             # 测试方法之前标记

pytest -m "smoke"              # 执行参数
```
3. 跳过测试用例
```python
@pytest.mark.skip（reason="还没写完"）                  # 无条件跳过
@pytest.mark.skipif（x==1,reason="符合条件所以跳过"）   # 有条件跳过
```

## 框架实现一些前后置（固件，夹具）的处理
1. 使用类方法实现
	1) setup、teardown：每条用例都会执行，既可以在类中使用，也可以在类外使用
	2) setup_class、teardown_class：类中的测试用例执行前后只执行一次
	3) setup_method、teardown_method：类中的每条测试用例执行前后都执行一次
	4) setup_function、teardown_function：类外的每条测试用例执行前后都执行一次
	5) setup_module、teardown_module：类外的测试用例执行前后只执行一次
```python
class Testcase:
    #这是每条测试用例执行前的初始化函数
    def setup(self):
        print("\n每条测试用例执行前的准备工作，比如：打开浏览器，加载页面等")
    #这是每条用例执行后的清理函数
    def teardown(self):
        print("\n每条测试用例执行后的清理工作，比如：关闭浏览器")
    #这是每个用例执行前的初始化函数
    def setup_class(self):
        print("\n所有测试用例执行前的准备工作，比如：链接数据库，打开文件等")
    #这是所有用例执行后的清理工作
    def teardown_class(self):
        print("\n所有测试用例执行后的清理工作，比如：断开数据连接，关闭文件等")
```

2. 使用fixture装饰器实现部分用例的前后置
```python 
@pytest.fixture(scope = "", params = "", autouse = "", ids = "", name = "")
def func():
	print('前置方法')
	yield
	print('后置方法')
```
- scope：fixture标记的方法的作用域，function（默认），class，module，package/session
```python
@pytest.fixture(scope = "function")
def test_01(self, func):
```
- params：参数化（支持list[]，元组()，字典列表[{}{}{}]，字典元组({}{}{}）
```python
@pytest.fixture(params = ['one','two','three'])
def fun(request){
	print('前置')
	yield request.param
	print('后置')
}
def test_01(self, fun):
	print(str(fun))
```
- autouse = True：自动执行，默认False
- ids：参数化时变量值
- name：被fixture所标记的方法（别名），后续不再使用方法名而是用name名

3. 通过conftest.py和pytest.fixture()结合使用实现全局的前置应用
	1) conftest.py文件是单独存放的一个夹具配置文件，名称是不能更改的
	2) 可以在不同的py文件中使用同一个fixture函数
	3) 原则上conftest.py需要和运行的用例放到同一层，并且不需要做任何import 



# 在测试中报告错误
## assert
## pytest.raises
[[Pytest#^13738e]]
## pytest.warns检查warning
## 使用pytest_assertrepr_compare定义错误信息

# Python的fixture
## Requesting fixture
- 可以在函数中通过传参的方式使用fixture修饰的函数的返回值，并且可以嵌套
```python
def fruit_bowl():
    return [Fruit("apple"), Fruit("banana")]

def test_fruit_salad(fruit_bowl):
    # Act
    fruit_salad = FruitSalad(*fruit_bowl)

    # Assert
    assert all(fruit.cubed for fruit in fruit_salad.fruit)

# Arrange 在这里，必须使用bowl获得fruit_bowl的结果作为test_的参数
bowl = fruit_bowl()
test_fruit_salad(fruit_bowl=bowl)
```
但是，在下面的代码中，fruit_bowl使用fixture的修饰，这样后面就可以直接使用该函数的返回值：
```python
class Fruit:
    def __init__(self, name):
        self.name = name
        self.cubed = False

    def cube(self):
        self.cubed = True

class FruitSalad:
    def __init__(self, *fruit_bowl):
        self.fruit = fruit_bowl
        self._cube_fruit()

    def _cube_fruit(self):
        for fruit in self.fruit:
            fruit.cube()

# Arrange
@pytest.fixture
def fruit_bowl():
    return [Fruit("apple"), Fruit("banana")]

def test_fruit_salad(fruit_bowl):
    # Act
    fruit_salad = FruitSalad(*fruit_bowl)

    # Assert
    assert all(fruit.cubed for fruit in fruit_salad.fruit)
```
- 可以使用多个函数作为参数
- 在参数中调用一次之后，结果会被缓存，在后面的使用中就会使用缓存的结果。比如在下面的调用中，参数中的append_first函数改变了order，那么在后面的assert中，order就是被改变过的值。

```python
@pytest.fixture  
def first_entry():  
    return "a"  
  
# Arrange  
@pytest.fixture  
def order():  
    return []  
  
# Act  
@pytest.fixture  
def append_first(order, first_entry):  
    return order.append(first_entry)  
  
  
def test_string_only(order, append_first, first_entry):  
    # Assert  
    assert order == [first_entry]
```
## 自动触发的fixture
```python
@pytest.fixture(autouse=True)
```
- 每个test被触发之前都会自动触发声明了autouse的函数
## 使用scope跨类、模块、包、任务地共享fixture
- 通过添加fixture的scope可以跨模块地创建一个公用的fixture
```python
@pytest.fixture(scope="module")
def smtp_connection():
	return smtplib.SMTP("smtp.gmail.com", 587, timeout=5)
```
- 这里的函数会预先创建一个smtp连接，后面如果多次使用这个函数创建的连接，则可以直接使用，不用再重新创建一个新的连接。





# Pytest API
## raise(expected_exception, match = "")

- 用于检查是否产生异常，可以检查一个异常或通过Tuple检查多个异常，如果产生了异常，则检查成功，否则检查失败。
```python
with pytest.raises(ZeroDivisionError):           # check success
	1/0
```
- 通过正则表达式匹配产生异常的字符
- 下面这种形式可以将函数以及函数的参数作为raise的参数，判断这个函数是否会产生期望的异常。
```python
pytest.raises(ExpectedException, func, *args, **kwargs)
```
- 