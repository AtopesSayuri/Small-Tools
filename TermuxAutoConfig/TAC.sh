#!/usr/bin/bash
#by AtopesSayuri

set -x

# 部分准备
termux-setup-storage
termux-wake-lock
CWD="$(pwd)"
TMP=AtopesTMP
mkdir -p ${TMP}
cd ${TMP}

# 字体替换
## 下载Jetbrain Nerdfont
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip -O JBM.zip
## 解压
unzip JBM.zip
## 替换字体
mv JetBrainsMonoNerdFont-Bold.ttf ${HOME}/.termux/font.ttf

# motd 修改
## 展示时间与用户
cat <<-EOF >>${PREFIX}/etc/profile
	LOGT="$(date +"%Y-%m-%d %H:%M:%S")"
	echo "Time: ${LOGT} | User: $(whoami)@$(hostname)"
EOF

# 夹点私货
## 打开项目主页
termux-open-url https://github.com/AtopesSayuri/Small-Tools

# 复位
termux-wake-unlock
cd ${CWD}
