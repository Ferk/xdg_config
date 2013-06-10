

if hash nproc 2>/dev/null
then
    alias make="make -j$((1+$(nproc)))"
elif [ -f /proc/cpuinfo ]
then
    alias make="make -j$((1+$(cat /proc/cpuinfo | grep -c processor)))"
fi

alias mk='make V=s 2>&1 | tee make.log | grep -ie "[^-\w]error" -e "^make"'

export PATH=$PATH:./scripts:./scripts/flashing

