#!/bin/bash

# ./scripts/feeds update -a && ./scripts/feeds install -a
# 请勿取消上面行的注释

LEDE_ROOT=$(pwd)

# 修改默认ip
sed -i 's/192.168.1.1/192.168.39.1/g' package/base-files/files/bin/config_generate
# 修改lede默认的腾讯云镜像为清华镜像
sed -i 's#mirrors.cloud.tencent.com/lede#mirrors.tuna.tsinghua.edu.cn/openwrt#g' package/lean/default-settings/files/zzz-default-settings
# 修改主机名
sed -i '/uci commit system/i\uci set system.@system[0].hostname='MikuWrt'' package/lean/default-settings/files/zzz-default-settings
sed -i 's/OpenWrt /MikuWrt /g'

mkdir package/community
pushd package/community

# 解锁网易云音乐
rm -rf ../lean/luci-app-unblockmusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git

# Mentohust 校园网上网
git clone --depth=1 https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git mentohust
git clone --depth=1 https://github.com/BoringCat/luci-app-mentohust.git

# 配置argon主题
[ -e ../lean/luci-theme-argon ] && rm -rf ../lean/luci-theme-argon
git clone -b 18.06 --depth=1 https://github.com/jerrykuku/luci-theme-argon.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git
sed -i 's/luci-theme-bootstrap/luci-theme-argon-18.06/g' feeds/luci/collections/luci/Makefile
[ -e $LEDE_ROOT/data/argon-background.jpg ] && mv $LEDE_ROOT/data/argon-background.jpg luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 在线设备列表
git clone --depth=1 https://github.com/Kerite/luci-app-onliner.git

# 关机
git clone https://github.com/esirplayground/luci-app-poweroff.git

#ddnsto和易有云
svn co https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto
svn co https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-linkease
svn co https://github.com/linkease/nas-packages/trunk/network/services/ddnsto
svn co https://github.com/linkease/nas-packages/trunk/network/services/linkease

# 应用过滤
git clone --depth=1 https://github.com/destan19/OpenAppFilter.git

popd
