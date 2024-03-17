#!/usr/bin/bash
#by AtopesSayuri

set -x

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
