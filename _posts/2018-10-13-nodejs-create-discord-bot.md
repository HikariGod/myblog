---
layout: post
title: 使用nodejs创建一个基础的discord bot机器人
date: 2018-10-13
categories: blog
tags: [discord,nodejs]
description: 教你如何创建一个基础的discord机器人
---

## 1.在Discord上创建开发人员应用程序

在你写机器人之前，必须要创建一个开发人员应用程序，你可以[点此链接](https://discordapp.com/developers/applications/me)去discord页面创建。

1.点击+号创建：
![> 01 Discord 开发人员应用程序01 图片](http://r6s.site/img/DiscordBot/DiscordApplications01.jpg)

2.修改机器人的名字和头像（记下CLIENT ID，后面要用到）：
![> 02 Discord 开发人员应用程序02 图片](http://r6s.site/img/DiscordBot/DiscordApplications02.jpg)
![> 03 Discord 开发人员应用程序03 图片](http://r6s.site/img/DiscordBot/DiscordApplications03.jpg)

3.创建Token（记下Token，后面的程序要用到，请保证你的Token不要泄露，不然会带来不必要的麻烦）：
![> 04 Discord 开发人员应用程序04 图片](http://r6s.site/img/DiscordBot/DiscordApplications04.jpg)
![> 05 Discord 开发人员应用程序05 图片](http://r6s.site/img/DiscordBot/DiscordApplications05.jpg)

4.创建你的邀请链接：
![> 06 Discord 开发人员应用程序06 图片](http://r6s.site/img/DiscordBot/DiscordApplications07.jpg)
![> 07 Discord 开发人员应用程序07 图片](http://r6s.site/img/DiscordBot/DiscordApplications08.jpg)

5.打开你的邀请链接，并把你的机器人邀请到你的服务器里（期间有谷歌人机验证，需要翻墙）：
![> 08 Discord 开发人员应用程序08 图片](http://r6s.site/img/DiscordBot/DiscordApplications09.jpg)

----

## 2.在服务器里安装nodejs

先进入node.js的官网，下载linux X64包到电脑里，地址：[download Node.js](https://nodejs.org/en/download/)，（我下的是v8.12.0版本，以下用此版本演示）

然后使用自己本机的压缩文件解压缩 node-v8.12.0-linux-x64.tar.xz 文件（PS：实在是搞不懂怎么在linux上怎么解压都解压不了，据说可以使用 tar -xvf 命令），然后重新压缩成.tar.gz文件，用ftp上传到你的linux服务器里。


解压刚刚上传的文件：

{% highlight ruby %}
tar -xf node-v8.12.0-linux-x64.tar.xz
{% endhighlight %}

名字有点长，把它弄短一点：

{% highlight ruby %}
mv node-v8.12.0-linux-x64 node-v8.12.0
{% endhighlight %}

创建软链接：

{% highlight ruby %}
ln -s /root/node-v8.12.0/bin/node /usr/local/bin/node  
ln -s /root/node-v8.12.0/bin/npm /usr/local/bin/npm
{% endhighlight %}

后面要用到forever，我们顺便也把它装了：

{% highlight ruby %}
npm install -g forever
{% endhighlight %}

会发现显示 bin/npm: line 1: ../lib/node_modules/npm/bin/npm-cli.js: No such file or directory 。

解决办法就是进入node的主目录，然后把修复的脚本下载下来运行：

如果curl不行，就使用wget的方法下载install.sh脚本

{% highlight ruby %}
cd /root/node-v8.12.0
curl https://npmjs.org/install.sh | sudo sh
bash install.sh
{% endhighlight %}

运行.sh脚本后会提示：

{% highlight ruby %}
[root@vultr node-v8.12.0]# bash install.sh
tar=/bin/tar
version:
tar (GNU tar) 1.23
Copyright (C) 2010 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by John Gilmore and Jay Fenlason.
install npm@latest
fetching: https://registry.npmjs.org/npm/-/npm-6.4.1.tgz
npm ERR! path /root/node-v8.12.0/bin/npx
npm ERR! code EEXIST
npm ERR! Refusing to delete /root/node-v8.12.0/bin/npx: is outside /root/node-v8.12.0/lib/node_modules/npm and not a link
npm ERR! File exists: /root/node-v8.12.0/bin/npx
npm ERR! Move it away, and try again.

npm ERR! A complete log of this run can be found in:
npm ERR!     /root/.npm/_logs/2018-10-09T06_51_13_165Z-debug.log
npm ERR! path /root/node-v8.12.0/bin/npx
npm ERR! code EEXIST
npm ERR! Refusing to delete /root/node-v8.12.0/bin/npx: is outside /root/node-v8.12.0/lib/node_modules/npm and not a link
npm ERR! File exists: /root/node-v8.12.0/bin/npx
npm ERR! Move it away, and try again.

npm ERR! A complete log of this run can be found in:
npm ERR!     /root/.npm/_logs/2018-10-09T06_51_28_752Z-debug.log
It failed
{% endhighlight %}

这个情况是已经存在旧的文件了，要清除旧的文件，我们进入bin里面，把名字改为_old，避免删除了后面弄坏了恢复不了：

{% highlight ruby %}
cd bin
mv npm npm_old
mv npx npx_old
cd ..
{% endhighlight %}

修改后回到node主目录，运行脚本：

{% highlight ruby %}
[root@vultr node-v8.12.0]# bash install.sh
tar=/bin/tar
version:
tar (GNU tar) 1.23
Copyright (C) 2010 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by John Gilmore and Jay Fenlason.
install npm@latest
fetching: https://registry.npmjs.org/npm/-/npm-6.4.1.tgz
removed 387 packages in 9.113s
/root/node-v8.12.0/bin/npm -> /root/node-v8.12.0/lib/node_modules/npm/bin/npm-cli.js
/root/node-v8.12.0/bin/npx -> /root/node-v8.12.0/lib/node_modules/npm/bin/npx-cli.js
+ npm@6.4.1
added 387 packages from 770 contributors in 9.822s
It worked
{% endhighlight %}

这时候运行npm命令就会有了help反应，我们继续安装forever:

{% highlight ruby %}
npm install -g forever
{% endhighlight %}

出现下面这种表示forever已经安装好了：

{% highlight ruby %}
[root@vultr node-v8.12.0]# npm install -g forever
/root/node-v8.12.0/bin/forever -> /root/node-v8.12.0/lib/node_modules/forever/bin/forever
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.4 (node_modules/forever/node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.4: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})

+ forever@0.15.3
added 242 packages from 153 contributors in 11.098s
{% endhighlight %}

运行一下forever试试：

{% highlight ruby %}
[root@vultr node-v8.12.0]# forever
bash: forever: command not found
{% endhighlight %}

![> 09 尴尬](http://r6s.site/img/biaoqin/wulian.jpg)
还真是多灾多难呢。

出现这种情况多半是软链接没建立好，使用下面这种方法建立一下forever的软链接：

{% highlight ruby %}
ln -s /root/node-v8.12.0/lib/node_modules/forever/bin/forever /usr/bin/forever
{% endhighlight %}

再用node -v看看版本，如果出现以下这种情况还是因为没有建立软链接，用一开始那个命令建立软链接即可：

{% highlight ruby %}
[root@vultr node-v8.12.0]# node -v
bash: node: command not found
{% endhighlight %}

软链接：

{% highlight ruby %}
ln -s /root/node-v8.12.0/bin/node /usr/local/bin/node  
ln -s /root/node-v8.12.0/bin/npm /usr/local/bin/npm
{% endhighlight %}

----

## 3.在服务器上创建你的机器人

先在root文件夹里面新建一个文件夹用来存放机器人脚本：

{% highlight ruby %}
cd /root
mkdir DiscordBot
cd DiscordBot
{% endhighlight %}

然后运行下面的命令来创建：

{% highlight ruby %}
npm init -y
npm install discord.js --save
{% endhighlight %}

把提供的脚本下载下来：

某大触的脚本地址：[PASTEBIN](https://pastebin.com/snJZBM0V)

把文件名字 simple_discord_bot.txt 改成 index.js

把 client.login("put your token here"); 内的 put your token here 替换成你的token

用FTP把index.js上传到服务器刚刚新建的文件夹内

在文件夹的路径下运行一下命令就可以开启了：

{% highlight ruby %}
node index.js
{% endhighlight %}

如果想要关闭Xshell后还能继续运行，就用forever启动：

{% highlight ruby %}
forever start index.js
{% endhighlight %}

到你的discord服务器输入sup hello测试一下吧！


----

参考资料：

[1][Linux系统（Centos）下安装nodejs并配置环境](https://blog.csdn.net/qq_21794603/article/details/68067821)

[2][Open MenuHow to Make a Discord Bot Using NodeJS by thepcgeek](https://www.instructables.com/id/How-to-Make-a-Discord-Bot-Using-NodeJS/)

[3][【求助】阿里云 CentOS 6.8 安装 forever](http://tieba.baidu.com/p/5117091739)

[4][npm 安装 bin/npm: line 1: ../lib/node_modules/npm/bin/npm-cli.js: No such file or directory](https://blog.csdn.net/jiankunking/article/details/69448618)