#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认IP地址
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate
# 修改主机名
sed -i "s/hostname='OpenWrt'/hostname='Pardofelis'/g" package/base-files/files/bin/config_generate
# 修改设备说明
sed -i '/openwrt_release/d' package/lean/default-settings/files/zzz-default-settings
sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION='QiYueYi $(date +"%y%m%d")'/g" package/base-files/files/etc/openwrt_release
# 写入设备型号
echo "DISTRIB_MODEL='X86_64-Sch'" >> package/base-files/files/etc/openwrt_release
# 调整 x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore
# 修改upx commit hash
sed -i "s/a46b63817a9c6ad5af7cf519332e859f11558592/1050de5171f70fd4ba113016e4db994e898c7be3/g" package/lean/upx/Makefile
# 调整 V2ray服务器 到 VPN 菜单
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm
# 修改内核文件
subtarget=$(grep -m 1 "CONFIG_TARGET_.*_.*=y" .config | sed "s/CONFIG_TARGET_\(.*\)_\(.*\)=y/\1\/\2/g")
for configFile in $(ls target/linux/$subtarget/config*)
do
    echo -e "\nCONFIG_NETFILTER_NETLINK_GLUE_CT=y" >> $configFile
done
