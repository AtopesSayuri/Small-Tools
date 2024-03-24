#!/usr/bin/bash
#by Atopes
#run this in termux

ROOT=0

if [[ "$(id -u)" == "0" ]]; then
	echo "You look down on me too much when you run this script with root privileges!!"
	exit 114
fi

# 文件夹检测
if [[ -e /data/adb ]]; then
	ROOT=$((${ROOT} + 10))
fi

# 挂载检测
MOUNTSCHECK=$(cat /proc/mounts | grep -i -e ksu -e magisk -e zygisk -e apatch -e overlay)
if [[ -n ${MOUNTSCHECK} ]]; then
	ROOT=$((${ROOT} + 25))
fi

# 调用命令返回值检测
su -c "exit"
ES=$?
if [[ $ES -eq 127 ]]; then
	ROOT=$((${ROOT} + 25))
fi

# ps 进程查询
PSRESUT=$(ps -ef)
PSCHECK=$(echo ${PSRESUT} | grep -i kernelsu && echo ${PSRESUT} | grep -i apatch && echo ${PSRESUT} | grep -i magisk)
if [[ -n ${PSCHECK} ]]; then
	ROOT=$((${ROOT} + 25))
fi

# prop 检测
if [[ "$(getprop ro.secureboot.lockstate)" == "locked" || "$(getprop sys.oem_unlock_allowed)" == "true" || "$(getprop ro.bootloader)" == "unknown" || "$(getprop ro.bootloader)" == "unlocked" ]]; then
	ROOT=$((${ROOT} + 10))
fi

# root 管理器查询 (不可信)
PKG=("me.bmax.apatch" "com.topjohnwu.magisk" "me.weishu.kernelsu" "io.github.vvb2060.magisk")
for i in $PKG; do
	if (pm path $i); then
		RMANAGER=$i
		ROOT=$((${ROOT} + 10))
	fi
done

echo "ROOT Possibility: ${ROOT}%"
