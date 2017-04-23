#!/bin/bash

# MIH - Minecraft Input Helper
# MIH - Minecraft输入辅助工具

# Authors: Hagb, kjiang

# Requires:
# 依赖项：
#	zenity
#	xdotool
#	xclip	(optional可选)
#	bash

helptext="Usage用法:
	mih.sh [--sign] [Timespan时间]
	--sign		Do not open the Minecraft input dialog
			(used while typing on a sign for example).
			不自动打开Minecraft聊天输入框(比如在牌子上输入)。
	[Timespan时间]	Specify timespan between each charcter input. Unit ms
			Recommend value is 100 (ms). I suggest you to only use
			this option when xclip is not working properly.
			If specified, MIH will try to put characters one by one
			in Minecraft instead of paste, leds more time consuming.
			指定向Minecraft输入字符时的间隔时间(毫秒)，建议值为100。
			只建议在xclip不能用的情况下设定该参数。如果使用该参数，
			MIH会往Minecraft里逐字输入而不是直接粘贴，导致速度更慢。

	mih.sh --help	Display this message. 显示本页面。"
time_s=0
if [ "$#" -gt 2 ]; then
	echo "Too many parameters 太多的参数" >&2
	echo -e "$helptext" >&2
	exit 1
fi
case $# in #参数处理
	"0");;
	"1")
		if [ "$1" = "--help" ]; then 
			echo -e "$helptext"
			exit 0
		fi
		if [ "$1" = "--sign" ]; then
			sign_mode=true
		elif grep '^[[:digit:]]*$' <<< "$1"; then #判断是否为数字
			if [ "$1" -lt 0 ]; then
				echo Invalid number 无效的数字 "$1"
				echo -e "$helptext" >&2
				exit 1
			else
				time_s="$1"
			fi
		else
			echo Invalid parameter 无效的参数 "$1"
			echo -e "$helptext" >&2
			exit 1;
		fi
		;;
	"2")
		if [ "$1" = "--sign" ]; then
			sign_mode = true
		fi
		if grep '^[[:digit:]]*$' <<< "$2"; then #判断是否为数字
			if [ "$1" -lt 0 ]; then
				echo Invalid number 无效的数字 "$2"
				echo -e "$helptext" >&2
				exit 1
			else
				time_s="$2"
			fi
		else
			echo Invalid parameter 无效的参数 "$2"
			echo -e "$helptext" >&2
			exit 1;
		fi
		;;
esac

# 在MC打开输入模式
if [ -f $sign_mode ]; then
	sleep 0.25
	xdotool key "t"
fi

# 打开输入框并接收输入的文字
#_mcchat_input="$(zenity --entry --text '保持 Minecraft 处于输入界面并在此输入内容：' --title 'Minecraft 输入辅助工具' )"
# 我需要让bash可以往zenity对话框发送ctrl+shift以达到自动开启输入法的目的，但如果直接使用上面的代码就会被阻塞。
# 这里采用的方法是让zenity独立成一个单独的线程，bash脚步继续执行并直接发送ctrl+shift，然后wait等待zenity结束运行。这期间zenity输入的所有文字都将暂时储存于临时文件里。
TEMP_FILE="/tmp/mih.$(( ( RANDOM % 65535 ) + 1 ))"	# 用来暂时储存输入文字的临时文件
#echo $TEMP_FILE
zenity --entry --text 'Keep Minecraft on top and type your message here:\n保持 Minecraft 处于输入界面并在此输入内容：' --title 'Minecraft Input Helper' > $TEMP_FILE &
# 自动切换输入法到中文（发送Ctrl+Shift快捷键到zenity对话框）
sleep 0.2
xdotool key ctrl+shift

# 从临时文件载入输入文字
wait	# 等待输入框完成输入
_mcchat_input=$(cat "$TEMP_FILE")
#echo $_mcchat_input
rm $TEMP_FILE	# 删除临时文件

if [[ "$_mcchat_input" = "" && -f "$sign_mode" ]]; then
	xdotool key Escape	# 关闭输入框
	exit 0
fi

# 将输入框中的文字输入到MC里
sleep 0.25
if [ $time_s -gt 0 ]; then
	# 逐字输入法
	xdotool type --delay $time_s "$_mcchat_input"
else
	# 复制粘贴法
	echo $_mcchat_input | xclip -i -selection clipboard
	xdotool key --delay $time_s ctrl+v
	#sleep .2
fi

# 回车发送
if [ -f $sign_mode ]; then
	xdotool key Return
fi
