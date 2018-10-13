---
layout: post
title: Permission denied 没有权限问题
date: 2018-10-11
categories: blog
tags: [teamspeak]
description: Teamspeak3服务器问题
---

切换teamspeak用户出现 bash: /home/teamspeak/.bashrc: Permission denied 问题的话，是因为没有权限所导致的，输入以下两行命令就可以赋予权限：

{% highlight ruby %}
chown -R teamspeak:teamspeak /home/teamspeak
chown -R teamspeak:teamspeak /etc/init.d/teamspeak
{% endhighlight %}

同样如果文件没有执行权限，出现Permission denied，可以使用以下方法赋予权限：

{% highlight ruby %}
chmod +x ts3server_startscript.sh #给文件“执行”的权限
chmod +w ts3server_startscript.sh #给文件“写”权限
chmod +r ts3server_startscript.sh #给文件“读”权限
{% endhighlight %}

参考资料：

[1][bash: /home/jxs/.bashrc: Permission denied 问题](http://bbs.chinaunix.net/thread-2199620-1-1.html)

[2][用CentOS6建立Teamspeak3服务器的方法](http://r6s.site/blog/2018/10/04/teamspeak-server-centos6/)

[3][linux运行文件出现“Permission denied”解决办法](https://www.fujieace.com/linux/permission-denied.html)