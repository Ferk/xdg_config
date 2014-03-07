# runs a git pull of the .config repo once a day
({
    cd $HOME/.config/
    timelimit=$(date +%m%d)0000
    touch -t $timelimit /tmp/timemarker
    if [ .git/FETCH_HEAD -ot /tmp/timemarker ]
    then
	git pull -q
    fi &
}&)
