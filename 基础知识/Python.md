# 基础知识
- 支持多重赋值
```python
a, b = b, a+b
```
- 函数的参数没有类型，可以随便传各种类型的参数



# 数据类型
## 字符串
- 字符串输出时，可以在前面加上r表示使用原始字符串
```python
print(r'C:\some\name')     # 这里的\n不会被解释成换行符
```
- 使用三重引号可以实现换行
```python
print("""\
Usage: thingy [OPTIONS]
     -h                        Display this usage message
     -H hostname               Hostname to connect to
""")
```
- 可以用`*`表示重复，用`+`表示字符串合并
- 字符串索引为负数表示从右边开始计数，-1表示右边第一个
- 可以使用`word[0:2]`表示范围内的数据
- 字符串中的数据不允许被修改

## 列表（相当于数组）
- 基本用法
```python
squares = [1, 4, 9, 16, 25]                # 基本赋值语句
squares[-3:]                               # 支持索引和切片，同时可以替换
squares = squares + [36, 49, 64, 81, 100]  # 增加新的数据
squares.append(216)                        # 调用append方法增加元素
squares[-1:] = [2, 3, 4, 5]                # 可以扩展元素数量
```



## 生成器
- 生成器类似于一个列表，但是它是根据一定的规律算法生成的，当我们去遍历它的时候，它可以通过特定的算法不断的推算出相应的元素，边运行边推算结果，从而节省了很多空间
- 生成器的表达式
```python
list_1 = [i for i in range(66666666)]      # 列表
list_2 = (i for i in range(66666666))      # 生成器，时间更快一些
```












# 关键字
## end
- end可以取消输出后面的换行, 或用另一个字符串结尾
```python
print(a, end=',')
```
## with
使用with语句，我们可以更加简洁地管理资源，避免手动关闭资源的繁琐操作。它能够提高代码的可读性和健壮性，减少资源泄露和错误发生的可能性。











## raise
- raise语句会手动产生一个异常

## del


## pass
- 不执行任何动作

## is


## with


## global

## nolocal

## finally

## yield


# 基本语法
## if
```python
if x < 0:
	x = 0
    print('Negative changed to zero')
elif x == 0:
    print('Zero')
elif x == 1:
    print('Single')
else:
    print('More')
```
## for
```python
users = {'Hans': 'active', 'Éléonore': 'inactive', '景太郎': 'active'}
# Strategy:  Iterate over a copy
for user, status in users.copy().items():      # 字典类需要由kay和value
    if status == 'inactive':
        del users[user]
```
- for和while循环可以有else语句，这个语句是在循环结束后退出循环时执行，如果不是因为循环结束而退出（比如break出来的）就不执行
## match（相当于switch）
```python
def http_error(status):
    match status:
        case 400:
            return "Bad request"
        case 404:
            return "Not found"
        case 418:
            return "I'm a teapot"
        case _:
            return "Something's wrong with the internet"
```






# 常用函数
## hasattr
- **hasattr()** 函数用于判断对象是否包含对应的属性。
```python
class RepVGGBlock():
    def __init__(self, deploy=False):
        if deploy:
            self.rbr_reparam = 1

    def forward(self):
        if hasattr(self, 'rbr_reparam'):
            print(1)
        else:
            print(0)

block1 = RepVGGBlock()
block1.forward()         # 0

block2 = RepVGGBlock(deploy=True)
block2.forward()         # 1
```
















# 常用模块
## 参数解析器——argparse
https://zhuanlan.zhihu.com/p/388930050?utm_id=0
### 创建
```python
parser = argparse.ArgumentParser()
```

```python
class argparse.ArgumentParser(prog=None, 
                                usage=None, 
                                description=None, 
                                epilog=None, 
                                parents=[], 
                                formatter_class=argparse.HelpFormatter, 
                                prefix_chars='-', 
                                fromfile_prefix_chars=None, 
                                argument_default=None, 
                                conflict_handler='error', 
                                add_help=True, 
                                allow_abbrev=True, 
                                exit_on_error=True)
```
- prog - 程序的名称（默认：sys.argv[0]）
- usage - 描述程序用途的字符串（默认值：从添加到解析器的参数生成）
- description - 在参数帮助文档之前显示的文本（默认值：无）
- epilog - 在参数帮助文档之后显示的文本（默认值：无）
- parents - 一个 ArgumentParser 对象的列表，它们的参数也应包含在内
- formatter_class - 用于自定义帮助文档输出格式的类
- prefix_chars - 可选参数的前缀字符集合（默认值：'-'）
- fromfile_prefix_chars - 当需要从文件中读取其他参数时，用于标识文件名的前缀字符集合（默认值：None）
- argument_default - 参数的全局默认值（默认值： None）
- conflict_handler - 解决冲突选项的策略（通常是不必要的）
- add_help - 为解析器添加一个 -h/--help 选项（默认值： True）
- allow_abbrev - 如果缩写是无歧义的，则允许缩写长选项 （默认值：True）
- exit_on_error - 决定当错误发生时是否让 ArgumentParser 附带错误信息退出。 (默认值: True)
### 添加参数
```python
parser.add_argument("build_type", type=str, help="Specify the build type")
```

```python
ArgumentParser.add_argument(name or flags...,
                            action='',
                            nargs='',
                            const,
                            default,
                            type,
                            choices,
                            required,
                            help,
                            metavar,
                            dest)
```
- name or flags: 参数有两种，一种是位置参数，一种是可选参数，对于位置参数来说，按照声明的顺序设置，这类参数前面没有前缀`-`，而可选参数前面有前缀`-`或`--`， 当`-`和`--`同时出现的时候，系统默认带'--'的为参数名，但是在命令行输入的时候没有这个区分
- action: 指定了命令行参数应该如何处理
	- store: 仅存储
	- store_const: 保存关键字const指定的值，如果在add_argument中赋值，则会报错
	```python
parser = argparse.ArgumentParser()  
parser.add_argument('--integers', action='store_const', const=563)  
args = parser.parse_args('--integers'.split())    # args = Namespace(integers=563)
	```
	- store_true、store_false: 仅能存储bool值
	```python
parser.add_argument('--t', action='store_true')
parser.add_argument('--f', action='store_false')
args = parser.parse_args(['--t', '--f'])
print(args)              #输出：Namespace(f=False, t=True)
```
	- append: 将同一个参数的不同值保存在一个list中
	- count: 统计出现的次数
	- extend: 存储一个列表，并将参数的每个不同值加入到列表中，可以一次输入多个值
- nargs: 
### 解析参数
```
args = parser.parse_args()
```

