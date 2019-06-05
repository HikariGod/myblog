---
layout: post
title: 使用MCSManager管理Minecraft服务器
date: 2019-05-30
categories: blog
tags: [Minecraft]
description: 使用MCSManager管理Minecraft服务器
---

其实安装的方法很简单，MCSManager的作者也说了喜欢简单和轻量,根据[官方文档](https://github.com/Suwings/MCSManager)也能进行安装

难的地方是配置nodejs的新版本，我不会配置就直接centos的yum旧版本用了，目前没什么大的问题（上次的discord机器人的nodejs搞得头疼）

安装git和nodejs

{% highlight ruby %}
yum -y install git
yum -y install nodejs
{% endhighlight %}

查看一下版本

{% highlight ruby %}
node -v
{% endhighlight %}

v6.16.0

嗯。。。 的确版本很旧

接下来安装MCSManager（其实就下载）

建议先创建一个screen，以便后台运行MCSManager

{% highlight ruby %}
git clone https://github.com/Suwings/MCSManager.git
{% endhighlight %}

克隆完这个库，安装依赖

{% highlight ruby %}
cd MCSManager
npm install --production
{% endhighlight %}

运行

{% highlight ruby %}
node app.js #或 npm start
{% endhighlight %}

从防火墙里把端口23333打开，阿里云直接后台防火墙打开就行了

然后访问你的域名:23333（默认端口可改）

{% highlight ruby %}
账号 #master
密码 123456
{% endhighlight %}

好像？？没了？？就这么简单？？

----

参考资料：

[Linux 下安装与使用详解
](https://github.com/Suwings/MCSManager/wiki/Linux-%E4%B8%8B%E5%AE%89%E8%A3%85%E4%B8%8E%E4%BD%BF%E7%94%A8%E8%AF%A6%E8%A7%A3)
