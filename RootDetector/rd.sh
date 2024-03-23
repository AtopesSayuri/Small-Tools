#!/usr/bin/bash
#by Atopes
#run this in termux

ROOT=0

# SELinux 检测
SELinuxState=$(/system/bin/getenforce)
if [[ "${SELinuxState}" == "Enforcing" || "${SELinuxState}" == "Disabled" ]]; then
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

# ps 进程查询
PSCHECK=$(ps -ef | grep -i -e kernelsu -e apatch -e magisk)
if [[ -n ${PSCHECK} ]]; then
	ROOT=$((${ROOT} + 25))
fi

# root 管理器查询 (不可信)
PKG=("me.bmax.apatch" "com.topjohnwu.magisk" "me.weishu.kernelsu" "io.github.vvb2060.magisk")
for i in $PKG; do
	if (pm path $i); then
		RMANAGER=$i
		ROOT=$((${ROOT} + 25))
	fi
done

echo "ROOT Possibility: ${ROOT}%"
