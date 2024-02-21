出现如下提示：
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:ZQH2os24w/umUQncTsBMMZWxGMrHVGkJbWK1AdXEO00.
Please contact your system administrator.
Add correct host key in C:\\Users\\cn1947/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in C:\\Users\\cn1947/.ssh/known_hosts:15
ECDSA host key for 10.10.184.1 has changed and you have requested strict checking.
Host key verification failed.
```
表示远程的密钥已更改，需要删掉本机存储的原来的密钥。