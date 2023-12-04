1. 首先导入全局配置
	- 如果当前已经进入了docker，则将`.docker_env`中的参数作为环境变量，删除`.docker_env`并取消该参数的声明；
	- 否则如果（）则保存环境变量并将其传给docker
	- 调用`config/utility_config`
		- 将 `/etc/os-release` 文件中的内容读取出来，并将其解释为 Shell 命令执行，将标准错误流重定向到`/dev/null`，使用`eval`设置环境变量。[[About Build System#^245d51]]
		- 判断当前处于那种状态（docker/host/cros_sdk）并设置context
		- 判断当前是否处于Jenkins build/gerrit review， 并设置当前状态码
		- 根据当前os版本设置不同package版本
	- 设置全局变量
	- 如果当前处于chromite/android，则设置不同的root文件系统
2. 获取输入参数
	- \*=\*形式的入参表示将参数作为环境变量传入，并且将参数作为环境变量导出：
```shell
if [[ ${saved_assign} != "" ]]; then
    eval "export ${saved_assign}"
fi
```
使用 `eval` 的目的是将 `saved_assign` 的值作为变量名进行导出。如果直接使用 `export saved_assign`，那么实际上会将名为 `saved_assign` 的变量导出为环境变量，而不是将 `saved_assign` 变量的值作为变量名导出。
举个例子，假设 `saved_assign` 的值为 `FOO=bar`。如果直接使用 `export saved_assign`，那么导出的环境变量将是 `saved_assign=FOO=bar`，而不是将 `FOO=bar` 导出为环境变量。这显然不是我们想要的结果。
通过使用 `eval`，我们可以将 `saved_assign` 的值作为命令进行求值，实际上执行的命令是 `export FOO=bar`，从而将 `FOO=bar` 导出为环境变量。

3. 执行utility中的脚本
4. 执行product_config配置
	- 执行product对应的config文件
		- 会export config文件中对应的module_config函数
	- 设置一些全局变量
5. 安装utility
	- 如果禁用安装或不处于host状态或处于快启动模式，则不安装
	- 安装python2、python3
	- 根据不同的系统，调用不同的命令安装软件
	- 检查是否存在安装软件包仓库，后续会使用ppa：https://blog.csdn.net/qq_43406338/article/details/111027654
	- 






