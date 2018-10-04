#!/bin/sh
# Copyright (c) 2010 TeamSpeak Systems GmbH
# All rights reserved
# chkconfig: 2345 99 00

COMMANDLINE_PARAMETERS="${2}" #add any command line parameters you want to pass here
D1=$(readlink -f "$0")
BINARYPATH="$(dirname "${D1}")"
cd "${BINARYPATH}"
LIBRARYPATH="$(pwd)"
BINARYNAME="ts3server"

case "$1" in
	start)
		if [ -e ts3server.pid ]; then
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "服务器已在运行，请尝试重启或停止"
				exit 1
			else
				echo "找到ts3server.pid，但没有服务器正在运行。 可能是您之前启动的服务器崩溃了"
				echo "请查看日志文件以获取详细信息"
				rm ts3server.pid
			fi
		fi
		if [ "${UID}" = "0" ]; then
			echo "警告 ！ 出于安全考虑，我们建议：不要将服务器作为ROOT运行"
			c=1
			while [ "$c" -le 10 ]; do
				echo -n "!"
				sleep 1
				c=$(($c+1))
			done
			echo "!"
		fi
		echo "启动TeamSpeak 3服务器"
		if [ -e "$BINARYNAME" ]; then
			if [ ! -x "$BINARYNAME" ]; then
				echo "${BINARYNAME} 是不可执行的，试图设置它"
				chmod u+x "${BINARYNAME}"
			fi
			if [ -x "$BINARYNAME" ]; then
				export LD_LIBRARY_PATH="${LIBRARYPATH}:${LD_LIBRARY_PATH}"					
				"./${BINARYNAME}" ${COMMANDLINE_PARAMETERS} > /dev/null &
 				PID=$!
				ps -p ${PID} > /dev/null 2>&1
				if [ "$?" -ne "0" ]; then
					echo "TeamSpeak 3服务器无法启动"
				else
					echo $PID > ts3server.pid
					echo "TeamSpeak 3服务器已启动，有关详细信息，请查看日志文件"
				fi
			else
				echo "${BINARNAME} 不可执行，无法启动TeamSpeak 3服务器"
			fi
		else
			echo "找不到二进制文件，正在中止"
			exit 5
		fi
	;;
	stop)
		if [ -e ts3server.pid ]; then
			echo -n "停止TeamSpeak 3服务器"
			if ( kill -TERM $(cat ts3server.pid) 2> /dev/null ); then
				c=1
				while [ "$c" -le 300 ]; do
					if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
						echo -n "."
						sleep 1
					else
						break
					fi
					c=$(($c+1)) 
				done
			fi
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "服务器没有干净地关闭 - 杀死"
				kill -KILL $(cat ts3server.pid)
			else
				echo "done"
			fi
			rm ts3server.pid
		else
			echo "No server running (ts3server.pid 不见了)"
			exit 7
		fi
	;;
	restart)
		$0 stop && $0 start ${COMMANDLINE_PARAMETERS} || exit 1
	;;
	status)
		if [ -e ts3server.pid ]; then
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "服务器正在运行"
			else
				echo "服务器似乎已经死了"
			fi
		else
			echo "没有服务器在运行 (ts3server.pid 不见了)"
		fi
	;;
	*)
		echo "用法: ${0} {start|stop|restart|status}"
		exit 2
esac
exit 0

