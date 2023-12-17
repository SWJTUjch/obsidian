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

