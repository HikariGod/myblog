---
layout: post
title: 用CentOS6建立Teamspeak3服务器的方法
date: 2018-10-04
categories: blog
tags: [teamspeak]
description: 建立Teamspeak3服务器
---

最近搭建ssr的CentOS6还有空闲的资源，我打算搭个teamspeak的服务器

----

一开始我直接使用了参考里面的开放端口设置：

{% highlight ruby %}
# Secure Iptables
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Teamspeak
iptables -I INPUT -p udp --dport 9987 -j ACCEPT
iptables -I INPUT -p udp --sport 9987 -j ACCEPT

iptables -I INPUT -p tcp --dport 30033 -j ACCEPT
iptables -I INPUT -p tcp --sport 30033 -j ACCEPT

iptables -I INPUT -p tcp --dport 10011 -j ACCEPT
iptables -I INPUT -p tcp --sport 10011 -j ACCEPT

# HTTP(s)
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --sport 80 -j ACCEPT

iptables -I INPUT -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp --sport 443 -j ACCEPT

# SSH
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -p tcp --sport 22 -j ACCEPT

# DNS
iptables -I INPUT -p udp --dport 53 -j ACCEPT
iptables -I INPUT -p udp --sport 53 -j ACCEPT

service iptables save && service iptables restart
{% endhighlight %}

使用后会导致我的ssr服务器连不上，可能是因为端口被关闭了，没有找到解决方法，我直接重新安装系统了

----

以下是搭建方法
在Xshell输入以下命令：

{% highlight ruby %}
# 开放ts服务器端口
iptables -I INPUT -p udp --dport 9987 -j ACCEPT
iptables -I INPUT -p udp --sport 9987 -j ACCEPT
iptables -I INPUT -p tcp --dport 30033 -j ACCEPT
iptables -I INPUT -p tcp --sport 30033 -j ACCEPT
iptables -I INPUT -p tcp --dport 10011 -j ACCEPT
iptables -I INPUT -p tcp --sport 10011 -j ACCEPT
service iptables save && service iptables restart

# 升级yum
yum -y update

# 添加一个用户（ts服务器不能在root用户中运行）
useradd teamspeak

# 下载和解压文件（因为客户端版本比较旧，我使用了比较旧的服务端）
cd /home/teamspeak
wget http://dl.4players.de/ts/releases/3.0.13/teamspeak3-server_linux_amd64-3.0.13.tar.bz2
tar -xf teamspeak3-server_linux_amd64-3.0.13.tar.bz2
cp -r /home/teamspeak/teamspeak3-server_linux_amd64/* /home/teamspeak/
rm -rf teamspeak3-server_linux_amd64-3.0.13.tar.bz2 && rm -rf teamspeak3-server_linux_amd64

# Add chkconfig support to startup file and link to binary
sed -i 's/# All rights reserved/# All rights reserved\n# chkconfig: 2345 99 00/g' ts3server_startscript.sh
ln -s /home/teamspeak/ts3server_startscript.sh /etc/init.d/teamspeak

# 赋予权限
chown -R teamspeak:teamspeak /home/teamspeak
chown -R teamspeak:teamspeak /etc/init.d/teamspeak

# 重新安装共享内存
mount -t tmpfs tmpfs /dev/shm

# 更改为Teamspeak用户并运行服务器
su teamspeak
./ts3server_startscript.sh start

echo "你的Teamspeak服务器的地址是: `curl ipv4.icanhazip.com`"
{% endhighlight %}

开启成功后，域名添加一个A记录，IP填写VPS的地址即可

sh脚本我机翻了一下，想要的可以下载：[点我下载](http://r6s.site/main/ts3server_startscript.sh)

我开启后遇到一个奇怪的问题，到现在都还没解决，连接服务器每隔5分钟左右就会断线一次，然后断线2分钟左右又会重新连接上，但是服务器的运行时间显示没有断过

参考资料：[Starting a Teamspeak 3 Server on CentOS 6.4 - Vultr.com](https://www.vultr.com/docs/starting-a-teamspeak-3-server-on-centos-6-4)