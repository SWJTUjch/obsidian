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
- for ubuntu 22.04
```shell
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/usr/bin/startxfce4
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
x-window-manager &
```
## Open vncserver
```shell
chmod +x ~/.vnc/xstartup
vncserver -geometry 1920x1080 -localhost no :1
vncconfig -nowin&
git clone "ssh://cn1947@gerrit-spsd.verisilicon.com:29418/Renesas/VSI/SIT"
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
## **查看**操作**系统版本**信息
```shell
cat /proc/version
lsb_release -a
```
## 创建新用户
 ```shell
sudo useradd -s /bin/sh -d /home/cn1947 cn1947
sudo passwd cn1947
sudo usermod -aG sudo cn1947
```
## 查看进程
```shell 
ps -ef|grep python
ps -ef | grep ttyUSB | grep -v root | awk '{print $2}' | xargs kill -9

```



ssh-keygen -R IP

find ./ "*.c" | xargs grep "hello world"



14号机的板子用的时候要是有问题，可以远程给板子断电，方法是：
1）远程10号机，打开cmd，ssh jenkins_test_auto@10.10.184.10
2）输入usbrelay，查看继电器状态，7和8是连接B0板子的，其他的不要去动

3）比如重启8号就是 先输入usbrelay 6QMBS_8=1 然后usbrelay 6QMBS_8=0，相当于按reset
忘了说了，6QMBS_8对应Jlink 69406615连接的板子







