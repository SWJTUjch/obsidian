https://mp.weixin.qq.com/s/K9KFryPijfvrxLF_rI_W9w

# 声明式pipeline
- 流水线过程必须全部定义在 `Pipeline{}`中，`Pipeline 块`定义了整个流水线中完成的所有工作
- 流水线顶层必须是一个 block，即 pipeline{}
- 块只能由 Sections、Directives、Steps 或 assignment statements 组成
- 属性引用语句被当做是无参数的方法调用，比如 input 会被当做 input()。
# 流水线式pipeline






# Sections
## agent
- any表示整个pipeline可以在任何一个可用的agent（Jenkins Node）上执行
- none表示整个pipeline没有指定agent，而是必须要由下面的stage来指定agent
- label表示整个pipeline/stage只能在指定label的agent上运行
- node可以添加额外的配置
```shell
pipeline {  
  agent none  
    stages {  
      stage('Stage For Build'){  
        agent {  
          node {  
            label 'role-master'  
            customWorkspace "/tmp/zhangzhuo/data"  
          }  
        }  
        steps {  
          sh "echo role-master > 1.txt"  
        }  
      }  
    }  
}
```
- dockerfile表示使用从源码中包含的 Dockerfile 所构建的容器执行流水线或 stage
```shell
agent {  
   dockerfile {  
     filename 'Dockerfile.build'  //dockerfile文件名称  
     dir 'build'                  //执行构建镜像的工作目录  
     label 'role-master'          //执行的node节点，标签选择  
     additionalBuildArgs '--build-arg version=1.0.2' //构建参数  
   }  
}
```
- docker表示可以直接使用该字段指定外部镜像，不用构建
```shell
agent{  
  docker{  
    image '192.168.10.15/kubernetes/alpine:latest'   //镜像地址  
    label 'role-master' //执行的节点，标签选择  
    args '-v /tmp:/tmp'      //启动镜像的参数  
  }  
}
```
## stages
定义流水线的执行过程（相当于一个阶段），比如下文所示的 Build、Test， 但是这个名字是根据实际情况进行定义的，并非固定的名字
```shell
pipeline {  
  agent any  
    stages {  
      stage('Build') {  
        steps {  
          echo 'Build'  
        }  
      }  
    }  
  }  
}
```
## post
## directives
## steps










