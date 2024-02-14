# Docker基本操作
- 镜像的唯一标识是ID和摘要
- 获取镜像
```bash
docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
# example
docker pull 192.168.103.43:5000/ubuntu/2004 default
```
- 运行镜像
```shell
docker run --user root -t --privileged ${docker_opt} -v ${base_home}:${base_home} -v ${HOME}:${HOME} -v ${docker_local}:${HOME}/.local ${current_docker_option} ${docker_image_to_run} /bin/bash -c "${command}"
```
- 列出镜像
	```shell
	docker image ls
	```
	- dangling image
		- 当新旧镜像同名时，会导致旧镜像的名字、仓库名和标签变为none，，可能是由于使用`docker pull`或者`docker build`引起的。可以使用如下命令显示这类镜像：
		```shell
		docker image ls -f dangling=true
		```
		- 可以使用如下命令删除dangling image：
		```shell
		docker image prune
		```
	- 可以使用如下命令列出中间层镜像：
	```shell
	docker image ls -a
	```
- 删除本地镜像
```shell
docker image rm xxxx
docker image rm $(docker image ls -q redis)
docker image rm $(docker image ls -q -f before=mongo:3.2)
```
# 使用Dockerfile定制docker镜像
## FROM执行基础镜像
## RUN执行命令
- shell格式：`RUN <shell command>`
- exec格式：'RUN \["可执行文件", "参数1", "参数2"\]'
- 每一次run会构建一层，所以如果执行了7次run就会构建7层，所以应该将多个命令写成一行
## 构建镜像
```shell
docker build -t nginx:v3 .      #在Dockerfile文件所在目录执行
```
这个过程中会启动一个容器，并且运行结束之后再销毁这个容器
