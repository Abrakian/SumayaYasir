#!/bin/bash
# CF WARP 优选

function warpcheck(){
case "$(uname -m)" in
	x86_64 | x64 | amd64 )
	curl -# --retry 2 https://proxy.freecdn.ml?url=https://raw.githubusercontent.com/fscarmen/warp/main/endpoint/warp-linux-amd64 -o warp
	;;
	i386 | i686 )
	curl -# --retry 2 https://proxy.freecdn.ml?url=https://raw.githubusercontent.com/fscarmen/warp/main/endpoint/warp-linux-386 -o warp
	;;
	armv8 | arm64 | aarch64 )
	curl -# --retry 2 https://proxy.freecdn.ml?url=https://raw.githubusercontent.com/fscarmen/warp/main/endpoint/warp-linux-arm64 -o warp
	;;
	armv7l )
	curl -# --retry 2 https://proxy.freecdn.ml?url=https://raw.githubusercontent.com/fscarmen/warp/main/endpoint/warp-linux-arm -o warp
	;;
	* )
	echo 当前架构$(uname -m)没有自动适配,请手动下载对应架构的WARP优选程序并命名位warp
	exit
	;;
esac
}

function cfwarp(){
if [ $menu == 1 ]
then
	n=0
	iplist=100
	while true
	do
		temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
	done
	while true
	do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
			n=$[$n+1]
		fi
	done
else
	n=0
	iplist=100
	while true
	do
		temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
	done
	while true
	do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
			n=$[$n+1]
		fi
	done
fi
echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u>ip.txt
ulimit -n 102400
chmod +x warp
./warp
clear
cat result.csv | head -11 | grep ms | awk -F, '{print "端点 "$1" 丢包率 "$2" 平均延迟 "$3}'
rm -rf ip.txt
exit
}

while true
do
	if [ ! -f "warp" ]
	then
		echo 从服务器下载warp优选程序
		warpcheck
	else
		break
	fi
done
clear
echo "1.WARP-V4优选"
echo "2.WARP-V6优选"
echo -e "0.退出\n"
read -p "请选择菜单(默认1): " menu
while true
do
	if [ -z "$menu" ]
	then
		menu=1
	fi
	if [ $menu == 0 ]
	then
		clear
		echo "退出成功"
		break
	fi
	if [ $menu == 1 ]
	then
		cfwarp
		break
	fi
	if [ $menu == 2 ]
	then
		cfwarp
		break
	fi
done
