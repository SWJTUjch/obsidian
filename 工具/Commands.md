# Remote desktop between Windows and Linux
## Install and config VNC in Linux
```shell
sudo apt-get install tigervnc-standalone-server
sudo apt-get install xfce4 xfce4-terminal
vi ~/.vnc/xstartup
```
## Modify VNC startup file
``` shell
#!/bin/sh 
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
gnome-session &
```
## Open vncserver
```shell
vncserver -geometry 1920x1080 -localhost no :1
vncconfig -nowin&
```
## Install ssh server
```shell
sudo apt-get install -y openssh-server
systemctl enable ssh #开机启动
sudo vim /etc/ssh/sshd_config
```
## ssh config
```shell
LoginGraceTime 20
MaxAuthTries 4
PermitRootLogin no
StrictModes yes
PubkeyAuthentication yes
#关闭PasswordAuthentication，避免root密码被暴力破解
PasswordAuthentication no
# server信任keys列表
AuthorizedKeysFile %h/.ssh/authorized_keys
```
## Generate ssh public key in Windows
```shell
ssh-keygen -t rsa
scp -r -P 22 id_rsa.pub username@ipaddress:~/Downloads/
```
## Linux
```bash
cat ~/Downloads/id_rsa.pub >> ~/.ssh/authorized_keys
vim /etc/ssh/sshd_config
```
## Close VNC
```shell
vncserver -kill :1
```


ssh-keygen -R IP

find ./ "*.c" | xargs grep "hello world"












