---
layout: post
title: TeamSpeak3服务器域名解析方法
date: 2018-4-15
categories: blog
tags: [域名解析]
description: 域名解析
---

因为TeamSpeak3服务器租聘的时候，服务器提供商会提供一个域名+端口的连接地址，正常情况下使用该域名+端口可以直接连接到这个语音服务器，但是自定义域名的话，按照<a href="http://ts1.cn/problem/ts3/213.html">《通过自有域名登录TS3》</a>的教程设置CNAME解析记录，就会出现进入该租聘商的默认试用服务器的情况，要用你的域名+端口才能进入自己服务器。
<br>
<br>该情况的正确解决方法为=>
<br>将CNAME解析记录修改为：<span style="color:red">SRV</span>记录
<br>主机记录：<span style="color:red">_ts3._udp.[自定义]</span>
<br>记录值：<span style="color:red">0 5 [端口号码] [IP/域名]</span>
<br>才能无需端口正常进入服务器。
<br><br>
<br>参考资料：<a target="_blank" href="http://www.zuimc.com/forum.php?mod=viewthread&tid=47131&highlight=ip">[联机] SRV解析/转发 服务器IP端口隐藏-域名转发</a>
