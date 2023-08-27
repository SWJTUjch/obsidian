vncserver -geometry 1920x1080 -localhost no :1
vncserver -kill :1
vncconfig -nowin&

ssh-keygen -R IP

find ./ "*.c" | xargs grep "hello world"












