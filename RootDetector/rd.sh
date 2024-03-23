#!/usr/bin/bash
#by Atopes
#run this in termux

ROOT=0

# 部分文件判断
if [[ -e /data/adb/ap || -e /data/adb/magisk || -e /data/adb/ksu ]]; then
	ROOT=$((${ROOT} + 25))
fi

# 挂载检测
MOUNTSCHECK=$(cat /proc/mounts | grep -i -e ksu -e magisk -e zygisk)
if [[ -n ${MOUNTSCHECK} ]]; then
	ROOT=$((${ROOT} + 25))
fi

# 调用命令返回值检测
su -c "exit"
ES=$?
if [[ $ES -eq 127 ]]; then
	ROOT=$((${ROOT} + 25))
fi
BIN=(/data/adb/apd /data/adb/ksud /data/adb/magiskd)
for i in ${BIN}; do
	if [[ -e ${i} ]]; then
		ROOT=$((${ROOT} + 25))
	fi
done

# root 管理器查询 (不可信)
PKG=("me.bmax.apatch" "com.topjohnwu.magisk" "me.weishu.kernelsu" "io.github.vvb2060.magisk")
for i in $PKG; do
	if (pm path $i); then
		ROOTDOUBT=true
		RMANAGER=$i
	else
		ROOTDOUBT=false
	fi
done

echo "ROOT Possibility: ${ROOT}%"
