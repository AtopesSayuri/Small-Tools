#!/usr/bin/bash
#by Atopes
#run this in termux

set -x

ROOT=false

# 部分文件判断
if [[ -e /data/adb/ap || -e /data/adb/magisk || -e /data/adb/ksu ]]; then
	ROOT=true
fi

# 挂载检测
MOUNTSCHECK=$(cat /proc/mounts | grep -i -e ksu -e magisk -e zygisk)
if [[ -n ${MOUNTSCHECK} ]]; then
	ROOT=true
fi

# 调用 su 命令返回值检测
su -c "exit"
ES=$?
if [[ $ES -eq 127 ]]; then
	ROOT=true
fi

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

if ${ROOT}; then
	echo "ROOTED."
elif ${ROOTDOUBT}; then
	echo "No ROOT. But ROOT manager is found: ${RMANAGER}"
else
	echo "No ROOT."
fi
