---
layout: post
title: PHP生成文件
date: 2018-5-156
categories: blog
tags: [PHP]
description: PHP生成文件
---

今天BH3群里团长想要做一些文件，里面都有一些特定的函数，我想了一下，做成了PHP给他生成了出来

----

{% highlight ruby %}
<?php  
if(isset($_POST['amount'])){ 
	$file_amount = $_POST['amount'];
	if($file_amount>3000){
		echo "<script>alert('抱歉，生成的数量不能超过3000！');window.location.href='index.php';</script>";
	}elseif(!is_numeric($$file_amount)){
		echo "<script>alert('抱歉，只能填写数字');window.location.href='index.php';</script>";
	}else{
		//$file_amount = 25;//根据自己要生成的数量自行填写（貌似最大限制是3958的样子）
		$file_str = strlen(floor($file_amount));//计算多少位数
		$datalist = array();
		for ($y=0; $y<=$file_amount; $y++) {//第一个循环创建文件
			$filename=str_pad($y,$file_str,"0",STR_PAD_LEFT);//在文件左边补0
			$myfile = fopen($filename.".txt", "w") or die("Unable to open file!");
			$datalist[] = $filename.".txt";
			$txt = "//Name,,\n@@Name,,\n";//添加文本前缀
			fwrite($myfile, $txt);//创建文本
			for ($x=0; $x<=$y; $x++) {//第二个循环制作文本内容，并将第一循环的数字为结尾
				$xx=str_pad($x,$file_str,"0",STR_PAD_LEFT);//在文件左边补0
				$txt = "@@".$xx.",*,\n";
				fwrite($myfile, $txt);//创建文本
			}
			$txt = "\n@@end\n\n//每一个表示一个图片";//添加文本后缀
			fwrite($myfile, $txt);//创建文本
			fclose($myfile);//关闭此次循环的文本编辑
		}
		//createFile($datalist);

		//function createFile($datalist){//创建打包下载程序
		$zipfilename = "@name.zip";
		//$datalist=array('./pubfile/1.jpg','./pubfile/2.jpg');
		if(!file_exists($zipfilename)){
			$zip = new ZipArchive();
			if ($zip->open($zipfilename, ZipArchive::CREATE)==TRUE) {
				foreach( $datalist as $val){
					if(file_exists($val)){
						$zip->addFile( $val, basename($val));
					}
				}
				$zip->close();
			}
		}
		if(!file_exists($zipfilename)){
			exit("无法找到文件");
		}
		header("Cache-Control: public");
		header("Content-Description: File Transfer");
		header('Content-disposition: attachment; filename='.basename($zipfilename)); //文件名
		header("Content-Type: application/zip"); //zip格式的
		header("Content-Transfer-Encoding: binary"); //告诉浏览器，这是二进制文件
		header('Content-Length: '. filesize($zipfilename)); //告诉浏览器，文件大小
		@readfile($zipfilename);
		@unlink($zipfilename);
		foreach( $datalist as $vale){
		   if(file_exists($vale)){
				@unlink($vale);
		   }
		  }
		//}
	}
}else{
?>
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0.5,maxinum-scale=2.0,user-scalable=yes"> 
<form action="index.php" method="post" name="form0" id="form0">
	<p></p>
	<p align="center" >生成文件</p>
		<table width="250" border="0" align="center">
			<tr>
				<td width="81" height="18">输入:</td>
				<td width="109"><input type="text" name="amount" /></td>
			</tr>
			<tr>
				<td></td>
				<td><input type="submit" name="Submit" value="生成" /></td>  
			</tr>
		</table>
	<p></p>
</form>
<?
}
?>
{% endhighlight %}