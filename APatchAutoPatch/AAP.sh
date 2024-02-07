#!/system/bin/sh
#by nya
#2024-02-06

RED="\E[1;31m"
YELLOW="\E[1;33m"
BLUE="\E[1;34m"
GREEN="\E[1;32m"
RESET="\E[0m"

# 参数解析
while getopts ":i:hvn" OPT; do
	case $OPT in
	i) # 处理选项i
		BOOTPATH="${OPTARG}"
		;;
	h | v)
		echo -e "${GREEN}"
		cat <<-EOF
			APatch Auto Patch Tool
			Written by nya
			        Version: 0.1.0

			-h, -v,                 print the usage and version

			-i [BOOT IMAGE PATH],   dpecify a boot image path.
			-n,                     do not install the patched boot image, save the image in ${WORKDIR}
		EOF
		echo -e "${RESET}"
		exit 0
		;;
	n)
		NOINSTALL=true
		echo -e "${BLUE}I: The -n parameter was received. Won't install after patch.${RESET}"
		;;
	:)
		echo "${YELLOW}Option -$OPTARG requires an argument..${RESET}" >&2 && exit 1
		;;

	?)
		echo "${RED}Invalid option: -$OPTARG${RESET}" >&2 && exit 1
		;;
	esac
done

# Android 检测
if [[ ! -e /vendor/build.prop ]]; then
	echo -e "${RED}E: RUN THIS SCRIPT IN ANDROID/TERMUX!!${RESET}"
	exit 1
fi
# ROOT 检测
if [[ "$(id -u)" != "0" ]]; then
	echo -e "${RED}E: RUN THIS SCRIPT WITH ROOT PERMISSION!${RESET}"
	exit 2
fi
# 判断用户输入的boot镜像路径是否正确
if [[ -n "${BOOTPATH}" ]]; then
	if [[ -e "${BOOTPATH}" ]]; then
		echo -e "${BLUE}I: Boot image path specified. Current boot path: ${BOOTPATH}${RESET}"
	else
		echo -e "${RED}E: SPECIFIED BOOT IMAGE PATH IS WRONG! NO SUCH FILE!${RESET}"
		exit 1
	fi
fi
# 判断用户设备是否为ab分区，是则设置$BOOTSUFFIX
if [[ ! -e /dev/block/by-name/boot ]]; then
	BOOTSUFFIX=$(getprop ro.boot.slot_suffix)
fi

SUPERKEY=${RANDOM}
WORKDIR=/data/adb/nyatmp

# 清理可能存在的上次运行文件
rm -rf ${WORKDIR}

mkdir -p ${WORKDIR}
echo -e "${BLUE}I: Downloading files from GitHub...${RESET}"
curl -L --progress-bar "https://github.com/nya-main/Small-Tools/raw/main/APatchAutoPatch/AAPFunction" -o ${WORKDIR}/AAPFunction
EXITSTATUS=$?
if [[ $EXITSTATUS != 0 ]]; then
	echo -e "${RED}E: SOMETHING WENT WRONG! CHECK YOUR INTERNET CONNECTION!${RESET}"
	exit 1
fi
curl -L --progress-bar "https://github.com/nya-main/Small-Tools/raw/main/APatchAutoPatch/pv" -o ${WORKDIR}/pv
EXITSTATUS=$?
if [[ $EXITSTATUS != 0 ]]; then
	echo -e "${RED}E: SOMETHING WENT WRONG! CHECK YOUR INTERNET CONNECTION!${RESET}"
	exit 1
else
	echo -e "${GREEN}I: Done.${RESET}"
fi

# 加载操作文件
source ${WORKDIR}/AAPFunction

get_device_boot
get_tools
patch_boot
if ${NOINSTALL}; then
	echo -e "${YELLOW}I: The -n parameter was received. Won't flash the boot partition.${RESET}"
	echo -e "${BLUE}I: Now copying patched image to /storage/emulated/0/patch_boot.img...${RESET}"
	./pv ${WORKDIR}/new-boot.img >/storage/emulated/0/patched_boot.img
	echo "${GREEN}I: Done.${RESET}"
	exit 0
else
	flash_boot
fi
