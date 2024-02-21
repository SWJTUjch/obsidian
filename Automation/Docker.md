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
```shell
FROM 192.168.103.43:5000/amd64/ubuntu:18.04
```
## RUN执行命令
- shell格式：`RUN <shell command>`
- exec格式：'RUN \["可执行文件", "参数1", "参数2"\]'
- 每一次run会构建一层，所以如果执行了7次run就会构建7层，所以应该将多个命令写成一行
- 每一层只添加真真需要的东西，任何无关的东西都要清理掉
```shell
RUN sed -i "s/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
    && sed -i "s/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
    && mkdir -p /etc/apt/apt.conf.d \
    && echo "Acquire::http::Timeout "180";" > /etc/apt/apt.conf.d/99timeout \
    && echo "Acquire::ftp::Timeout "180";" >> /etc/apt/apt.conf.d/99timeout \
    && apt-get update && apt-get -y upgrade \
    && apt-get install -y apt-utils sudo
```
## 构建镜像
```shell
docker build [选项] <上下文路径/URL/->
docker build -t nginx:v3 .      #在Dockerfile文件所在目录执行
```
这个过程中会启动一个容器，并且运行结束之后再销毁这个容器。
- 后面跟着的点标识docker运行的上下文，也就是在docker运行时，把这个上下文目录打包传递给docker引擎，接下来docker就会在这个目录下执行，包括dockerfile中的COPY等命令，所使用的相对路径也都是基于这个上下文的。因此，Dockerfile只能使用当前目录下的文件，而无法使用父目录中的文件。
- 应该将 Dockerfile 置于一个空目录下，或者项目根目录下。如果该目录下没有所需文件，那么应该把所需文件复制一份过来。如果目录下有些东西确实不希望构建时传给 Docker 引擎，那么可以用 .gitignore 一样的语法写一个 .dockerignore
## COPY复制文件
- 格式：COPY <源路径1>... <目标路径>
- 源路径可以有多个，可以使用通配符
- <目标路径> 可以是容器内的绝对路径，也可以是相对于工作目录的相对路径（工作目录可以用 WORKDIR 指令来指定）。目标路径不需要事先创建，如果目录不存在会在复制文件前先行创建缺失目录。
```shell
COPY utility/apt_install.txt /build/utility/
```
## ADD更高级的复制文件
- 所有的文件复制均使用COPY 指令，仅在需要自动解压缩的场合使用 ADD
- 如果 <源路径> 为一个 tar 压缩文件的话，压缩格式为 gzip , bzip2 以及 xz 的情况下， ADD 指令将会自动解压缩这个压缩文件到 <目标路径> 去。
- 源路径可以可以是一个URL，下载后权限为600，如果需要更改权限，需要使用RUN
## CMD容器启动命令
- CMD 指令就是用于指定默认的容器主进程的启动命令的。

