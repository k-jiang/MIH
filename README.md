# MIH - Minecraft Input Helper
A Minecraft input helper for Linux ime tools. Linux下的Minecraft输入辅助工具  
## Why Use This ? 解决的问题
Linux下的输入法不认Minecraft输入框导致无法输入中文  
## Dependencies 依赖项
* zenity  
* xdotool
* xclip
* bash
  
## Usage 使用方法
把此工具与快捷键绑定，在Minecraft输入时，使用系统快捷键调出工具，输入后回车即可。  
```
Usage用法:
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

	mih.sh --help	Display this message. 显示本页面。
```
## Capability 适用版本
* \>=Minecraft 1.9
* <=Minecraft 1.8.9 (带中文输入补丁)

## Notice 说明
This script is modified based on Hagb's MIH tool https://github.com/Hagb/MIH. I have improved it so that it can run faster and could auto switch between ime (by sending Ctrl+Shift, see bash code for details). If you have any problem using this script you can try Hagb's origional MIH script.
此脚本修改自Hagb的MIH https://github.com/Hagb/MIH ，我在原来的基础上添加了些许优化，比如缩短等待时间，自动打开输入法（发送Ctrl+Shift，请看源代码）等等。如果在使用上遇到任何问题可以考虑使用Hagb的脚本。
