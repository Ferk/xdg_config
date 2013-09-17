

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

