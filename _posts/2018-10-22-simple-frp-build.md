---
layout: post
title: 简单使用frp搭建一个内网穿透
date: 2018-10-22
categories: blog
tags: [frp]
description: 简单使用frp搭建一个内网穿透
---

![> 01 尴尬](http://r6s.site/img/biaoqin/wulian.jpg)

因为一个星期前搭建的ngrok服务端能运行，客户端死活连不上，我放弃了ngrok

发现frp的方法简单快捷，就打算试试了

先从frp的github中下载版本[frp Releases](https://github.com/fatedier/frp/releases)

我是下的frp_0.21.0_linux_amd64.tar.gz，以下都用这个来做示范

先下载文件和解压缩

里面会有6个文件

{% highlight ruby %}
frps #服务端
frps.ini #服务端配置文件
frps_full.ini #服务端示范配置文件
frpc #客户端（如果是windows，是frpc.exe）
frpc.ini #客户端配置文件
frpc_full.ini #客户端示范配置文件
{% endhighlight %}

如果你客户端用的是windows，要再去下载frp_0.21.0_windows_amd64.zip

打开frps.ini文件，修改服务端配置文件：

{% highlight ruby %}
[common]
bind_addr = 0.0.0.0
bind_port = 7000
token = xz65q3zgfx8qx
vhost_http_port = 8080
subdomain_host = frp.r6s.site
dashboard_port = 7500
dashboard_user = user
dashboard_pwd = password
{% endhighlight %}

注释：

{% highlight ruby %}
[common]
#服务端的IP（一般留空就好了）
bind_addr = 0.0.0.0

#服务端与客户端通讯的端口（记得在防火墙里开放这个端口）
bind_port = 7000

#服务端与客户端通讯的验证码（自定义，跟客户端一样就好了）
token = xz65q3zgfx8qx

#网页的端口（因为80端口被占用了，无奈要在域名后面加端口，这个也要在防火墙开放端口）
vhost_http_port = 8080

#自定义域名（二级域名也没问题，记得添加A记录）
subdomain_host = frp.r6s.site

#隧道状态查询网页的端口（这个也要在防火墙开放端口 ，如果不要状态查询，删除查询端口账户密码即可）
dashboard_port = 7500

#查询网页的账户名
dashboard_user = user

#查询网页的密码
dashboard_pwd = password
{% endhighlight %}

然后再打开frpc.ini，这个是客户端配置文件：

{% highlight ruby %}
[common]
server_addr = xxx.xxx.xxx.xxx
server_port = 7000
token = xz65q3zgfx8qx

[web01]
type = http
local_ip = 127.0.0.1
local_port = 80
subdomain = test
{% endhighlight %}

注释：

{% highlight ruby %}
[common]
#服务器IP地址
server_addr = xxx.xxx.xxx.xxx

#服务端与客户端通讯的端口（跟服务端的配置文件一样）
server_port = 7000

#服务端与客户端通讯的验证码（跟服务端一样就好了）
token = xz65q3zgfx8qx

#命名，不要相同命名，不然会出错
[web01]

#类型选择http（其他类型看实例演示配置文件）
type = http

#本地访问的IP地址
local_ip = 127.0.0.1

#本地访问的端口
local_port = 80

#自定义二级或者三级域名（我这个示范的访问地址是test.frp.r6s.site:8080）
subdomain = test
{% endhighlight %}

配置文件完成后，用ftp把frps和frps.ini上传上去服务器

因为要在后台长存，我们用screen来开启：

{% highlight ruby %}
screen -S frp
{% endhighlight %}

<span style="color:red">注意：</span>这个<span style="color:gray">-S</span>一定要用大写S

打开一个会话之后，在里面输入指令就可以开启了： 

{% highlight ruby %}
./frps -c ./frps.ini
{% endhighlight %}

如果没有权限，赋予一下权限：

{% highlight ruby %}
chmod +x frps
chmod +w frps
chmod +r frps
chmod +x frps.ini
chmod +w frps.ini
chmod +r frps.ini
{% endhighlight %}

开启好后可以使用Ctrl+A D返回进入会话前的状态

如果想了解screen的其他用法，请点这网址：[Linux操作系统下Screen命令的简单使用方法](https://blog.csdn.net/lwm1986/article/details/1725617)

服务端开好后，我们继续开客户端：

同样的方法把frpc和frpc.ini上传好

用screen创建一个会话，并在里面运行：

{% highlight ruby %}
./frpc -c ./frpc.ini
{% endhighlight %}

Windows用户可以使用以下方法：

在frpc.exe和frpc.ini的文件夹内右键，然后选择“在此处打开powershell”

然后输入：

{% highlight ruby %}
./frpc -c ./frpc.ini
{% endhighlight %}

如果右键没有看见“在此处打开powershell”的话，可以试试以下方法：

用开始菜单搜索powershell打开

看下输入命令前面的地址在哪，我的是：“C:\Users\Administrator”

打开“C:\Users\Administrator”，把刚刚客户端的两个文件扔进去

在powershell输入上面的命令

这样就大功告成了

只不过遗憾的是我的VPS是在新加波，这个访问得很慢，如果是在国内的话，应该会访问快一点

可以参考一下别人已经搭建好的frp：[FRP内网穿透](https://diannaobos.com/frp/)

----

参考资料：

[1][十分钟教你配置frp实现内网穿透](https://blog.csdn.net/u013144287/article/details/78589643)

[2][外网通过frp访问局域网win10电脑本地web服务](https://jingyan.baidu.com/article/9c69d48ff8813813c9024e97.html)

[3][Linux操作系统下Screen命令的简单使用方法](https://blog.csdn.net/lwm1986/article/details/1725617)

[4](如何用 Frp 实现外网访问群晖 NAS)https://segmentfault.com/a/1190000009895225)
