

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
	for file in package/heatapp/ebvnode/Makefile
	do
		touch "$file"
	done
    {
	if make V=s "$@" 2>&1
	then
	    echo -e "\e[32m; -- Finished with successful error code ($?)!"
	else
	    echo -e "\e[31m; -- Returned error code: $? ...see make.log for full log"
	fi
    } | \
	tee make.log | grep -ie "[^-_\w]error" -e "^make.*: Entering directory"
    echo -e "\a"
	beep -f90 -l20
}

export PATH=$PATH:./scripts:./scripts/flashing

alias linux-rebuild="make target/linux/{clean,compile,install} V=s"
alias linux-initcalls="./staging_dir/toolchain-*/bin/*-openwrt-linux-objdump -x build_dir/target-*/linux-*/linux-*/vmlinux | grep __initcall_"


function openwrt-gcc() {
	( eval "$(grep --color=never .config -e '^[^-]\+=')"

		export STAGING_DIR=$(find .  -maxdepth 2  -type d -wholename "*/staging_dir/target-${CONFIG_ARCH}*" | head -n1)
		export TOOLCHAIN_DIR=$(find .  -maxdepth 2  -type d -wholename "*/staging_dir/toolchain-${CONFIG_ARCH}*" | head -n1)
		GCC_ARGS=$CONFIG_TARGET_OPTIMIZATION

		[ "$TOOLCHAIN_DIR" ] && [ "$STAGING_DIR" ] || return 1
		
		$TOOLCHAIN_DIR/bin/arm-openwrt-linux-gcc ${GCC_ARGS} "$@"
	)
}


alias rootdu="ncdu staging_dir/target-*/target-*/root-*"
