# 基础知识
- 支持多重赋值
```python
a, b = b, a+b
```

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















# 关键字
## end
- end可以取消输出后面的换行, 或用另一个字符串结尾
```python
print(a, end=',')
```













## raise
- raise语句会手动产生一个异常

## del


## pass


## is


## with


## global

## nolocal

## finally

## yield


# 基本语法


# 常用函数

