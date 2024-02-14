# mac build
- build出现权限问题：需要免密并且开启xcode


# linux ssh windows
- 把linux的id_rsa.pub复制到windows的authorized_key，不能出现任何其他字符
- 如果要ssh之后直接使用powershell，要在windows执行
```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
```









# linux environment
## build system
- 出现usage提示以及add user docker，可能是由于当前username有问题，可以退出重新登陆
- 出现下图问题：
![](cannot_connect_docker.png)
https://www.cnblogs.com/Zhou-Tx/p/17713177.html
```shell
sudo gpasswd -a $USER docker
# 或
sudo usermod -a -G docker $USER
# 查看docker.socket配置
cat /usr/lib/systemd/system/docker.socket
[Unit]
Description=Docker Socket for the API
 
[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660     # change to 666
SocketUser=root
SocketGroup=docker
 
[Install]
WantedBy=sockets.target

```

https://coding-app1.verisilicon.com/books/