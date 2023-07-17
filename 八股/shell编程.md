# shell编程
```
#!/bin/bash			//声明使用的是什么shell解析器
```
## 执行一个shell脚本
chmod u+x xxx.sh
```
./hello.sh
sh hello.sh
```

## 条件判断语句
### 成功的返回值为0，失败的返回值为非0
### test语句
- test 语句
比如测试文件类型:
```
test -b /etc
echo $?
```
- 常用文件测试

|命令|含义|
|---|---|
|-b filename | 当filename 存在并且是块文件时返回真(返回0)|
|-c filename | 当filename 存在并且是字符文件时返回真|
|-d pathname | 当pathname 存在并且是一个目录时返回真|
|-e pathname | 当由pathname 指定的文件或目录存在时返回真|
|-f filename | 当filename 存在时返回真|
|-g pathname | 当由pathname 指定的文件或目录存在并且设置了SGID 位时返回真|
|-h filename | 当filename 存在并且是符号链接文件时返回真 (或 -L filename)|
|-k/L pathname | 当由pathname 指定的文件或目录存在并且设置了"粘滞"位时返回真|
|-p filename | 当filename 存在并且是命名管道时返回真|
|-r pathname | 当由pathname 指定的文件或目录存在并且可读时返回真|
|-s filename | 当filename 存在并且文件大小大于0 时返回真|
|-S filename | 当filename 存在并且是socket 时返回真|
|-t fd | 当fd 是与终端设备相关联的文件描述符时返回真|
|-u pathname | 当由pathname 指定的文件或目录存在并且设置了SUID 位时返回真|
|-w pathname | 当由pathname 指定的文件或目录存在并且可写时返回真|
|-x pathname | 当由pathname 指定的文件或目录存在并且可执行时返回真|
|-O pathname | 当由pathname 存在并且被当前进程的有效用户id 的用户拥有时返回真(字母O 大写)|
|-G pathname | 当由pathname 存在并且属于当前进程的有效用户id 的用户的用户组时返回真|

- 常见字符串测试

|命令|含义|
|---|---|
|-z string|字符串string为空串时返回真|
|-n string|字符串string为非空串时返回真|
|str1 = str2|str1和str2相等时返回真|
|str1 == str2|同上|
|str1 != str2|不相等时返回真|

- 常见数值测试

|测试条件|命令|
|---|---|
|==|eq|
|!=|ne|
|>|gt|
|>=|ge|
|<|lt|
|<=|le|

- 常见逻辑操作符

|命令|含义|
|---|---|
|a|and|
|o|or|
|!|not|

### if
```
if [判断语句]; then			//如果then和if在同一行，前面就要加分号，否则就不用加
	xxx
	xxx
elif [判断语句]; then
	xxx
else
	xxx
fi
```
- if和中括号之间有一个空格
- []中的判断语句前后必须有一个空格
- [[ ]]中的逻辑操作符可以使用&&或||

### case
- 可以使用通配符

```
case 变量 in
yes|Yes|y|Y)
	xxx
	xxx
	;;
No|no|n|N)
	xxx
	xxx
	;;
*)
	xxx
	xxx
	;;
esac
```


### 循环语句
- for/do/done

```
for 变量 in list（列表）;do
	xxx
	xxx
done
```
例：
```
for VAR in $(ls);do
	echo $VAR
done
```

- while/do/done

```
while [ 条件测试语句 ];do
	xxx
	xxx
done
```
例：登录时输入密码，如果输入错误则再次输入
read可以获取用户从终端输入的数据

```
PWD=world
count=1
read TMP
while[ TMP != $PWD -a count -le 3 ];do
	echo "密码错误："
	read TMP
	count=$[count+1]
done
```



- break和continue



## 常用特殊变量
- $#：shell脚本执行时传递的参数个数
	- ./xx.sh aa bb cc dd 从aa开始数，参数的个数
- $?：上一条命令执行的返回值
- $@：所有的参数，for循环时会有多少个参数就拆分成几个部分
- $*：所有的参数，for循环时会将所有的参数作为一个整体
- $0：文件名
- $1：第一个参数

## 普通变量
- 变量都默认是字符串
- 变量的定义： `var=1`
- 赋值操作：等号左右不能有空格，如果有空格则表示判断
- 删除变量：`unset var`
- 将命令执行之后的值赋值给变量
	- var=`date`
	- var=&(date)
- 算术运算先取值再运算
	- $(($var+3))
	- $[$var+4]
- export var：把var设置为临时的环境变量
	- 如果要是指变为永久的环境变量，也可以修改~/.bashrc或/etc/profile
- 进制运算：`$[base#n]`——base是进制，#是连接符，n是base进制的数值



## 其他常用语句
- exit 0：退出当前进行
- 转义字符
- 单引号：`var='$(date)'`表示把括号里面的值赋给var
- 双引号：`var='$(date)'`和不加是一样的，会解析字符串中的命令，赋值给var
- 冒号：一个空命令，什么时候都是真

### 输入和输出
- echo
	- -e：解析字符串中的\n字符
	- -n：去掉echo默认加上的换行符
- 重定向
	- cmd>file：重定向输出
	- cmd>>file：追加添加
	- cmd 1>file 2>&1：标准输出重定向到file中，标准错误重定向到标准输入中，&表示是一个文件描述符





