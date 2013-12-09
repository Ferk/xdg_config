

# export OPENWRT=$HOME/sama5/heatsvn/openwrt/
# export STAGING_DIR=$OPENWRT/staging_dir/
# export PATH=$STAGING_DIR/host/bin:$PATH:$STAGING_DIR/toolchain-arm_v7-a_gcc-4.6-linaro_uClibc-0.9.33.2_eabi/bin

# export CROSS_OPTS='HOSTCFLAGS="-O2 -I/SAMA53EK/new/staging_dir/host/include -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="arm-openwrt-linux-uclibcgnueabi-" ARCH="arm"'



# make -C /SAMA53EK/new/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/linux-at91sama5/linux-3.10 HOSTCFLAGS="-O2 -I/SAMA53EK/new/staging_dir/host/include -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="arm-openwrt-linux-uclibcgnueabi-" ARCH="arm" KBUILD_HAVE_NLS=no CONFIG_SHELL="/usr/bin/bash" V='' CC="arm-openwrt-linux-uclibcgnueabi-gcc" INSTALL_HDR_PATH=/SAMA53EK/new/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/linux-at91sama5/linux-3.10/user_headers headers_install

# make -C /SAMA53EK/new/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/linux-at91sama5/linux-3.10 HOSTCFLAGS="-O2 -I/SAMA53EK/new/staging_dir/host/include -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="arm-openwrt-linux-uclibcgnueabi-" ARCH="arm" KBUILD_HAVE_NLS=no CONFIG_SHELL="/usr/bin/bash" V='' CC="arm-openwrt-linux-uclibcgnueabi-gcc" modules


# make -C /SAMA53EK/new/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/linux-at91sama5/linux-3.10 HOSTCFLAGS="-O2 -I/SAMA53EK/new/staging_dir/host/include -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="arm-openwrt-linux-uclibcgnueabi-" ARCH="arm" KBUILD_HAVE_NLS=no CONFIG_SHELL="/usr/bin/bash" V='' CC="arm-openwrt-linux-uclibcgnueabi-gcc" 

# make -C /SAMA53EK/new/build_dir/target-arm_v7-a_uClibc-0.9.33.2_eabi/linux-at91sama5/linux-3.10 HOSTCFLAGS="-O2 -I/SAMA53EK/new/staging_dir/host/include -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="arm-openwrt-linux-uclibcgnueabi-" ARCH="arm" KBUILD_HAVE_NLS=no CONFIG_SHELL="/usr/bin/bash" V='' CC="arm-openwrt-linux-uclibcgnueabi-gcc" dtbs


if hash nproc 2>/dev/null
then
    alias make="make -j$((1+$(nproc)))"
elif [ -f /proc/cpuinfo ]
then
    alias make="make -j$((1+$(cat /proc/cpuinfo | grep -c processor)))"
fi

mk() {
    {
	if make V=s "$@" 2>&1
	then
	    echo "Finished with successful error code ($?)!"
	else
	    echo "Returned error code: $? ...see make.log for full log"
	fi
    } | \
	tee make.log | grep -ie "[^-_\w]error" -e "^make.*: Entering directory"
    echo -e "\a"
}

export PATH=$PATH:./scripts:./scripts/flashing

alias linux-rebuild="make target/linux/{clean,compile,install} V=s"
