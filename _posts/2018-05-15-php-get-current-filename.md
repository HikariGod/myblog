---
layout: post
title: PHP获取自己文件的名字
date: 2018-4-15
categories: blog
tags: [PHP]
description: PHP获取自己文件的名字
---

将以下代码复制进你的程序中，使用getCurrentFilename()调取即可

{% highlight ruby %}
function getCurrentFilename(){
  $url = $_SERVER['PHP_SELF'];
  $filename = substr( $url , strrpos($url , '/')+1 );
  return $filename;
}
{% endhighlight %}