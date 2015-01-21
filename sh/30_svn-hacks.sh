#!/bin/sh
#
# svn wrapper with some useful hacks that make my life easier.
#

SVN_BIN=$(which svn 2>/dev/null)

[ "$SVN_BIN" ] || return

_jira_task_query() {
	search_cmd="$*"

	#wget -q -O- --user="$JIRA_USER" --password="$JIRA_PASSWD" --header="Content-Type: application/json"  "$JIRA_URL/rest/api/2/search?jql=${search_cmd//[ ]/%20}"
	curl --silent -D- -u "$JIRA_USER:$JIRA_PASSWD" -X GET -H "Content-Type: application/json" \
		"$JIRA_URL/rest/api/2/search?jql=${search_cmd//[ ]/%20}" | grep --color=never '{.*}' \
		| jsonpipe | awk '
/\/issues\/[0-9]+\/key/ {i=gensub(/\/issues\/([0-9])+\/.*/,"\\1",$1); $1=""; key[i]=$0}
/\/issues\/[0-9]+\/fields\/summary/ {i=gensub(/\/issues\/([0-9])+\/.*/,"\\1",$1); $1=""; summary[i]=$0}
END{
  for (i in key){
    print  key[i] " - " summary[i];
  }
}
' 2>&1


}

_svn_jira_info() {

	[ "$JIRA_URL" ] || return

	echo "-- my jira tasks --"
	_jira_task_query "resolution = Unresolved AND assignee=$JIRA_USER ORDER BY priority DESC, issuetype ASC, updated DESC, due ASC, status DESC"

	#echo "-- flagged --"
	#
}

_svn_editor_cmd() {
	template_file="${@}"

	cat <<EOF >> "${template_file}"

$(_svn_jira_info)
${SVN_TEMPLATE_EXTRA}

-- svn diff $SVN_ARGS --
$($SVN_BIN diff "$SVN_ARGS" 2>&1)a

-- svn info $SVN_ARGS --
$($SVN_BIN info "$SVN_ARGS" 2>&1)

EOF
	
	${EDITOR:-vi} "${template_file}"
}

svn() {
	case $1 in

		commit|ci)
			shift
			# only forward args if there are no special options to the commit
			if ! echo "$@" | grep -q ' -'
			then
				export SVN_ARGS="$@"
			fi

			(
				SVN_EDITOR=". '$(readlink -f "$BASH_SOURCE")' && $(env | grep --color=never '^JIRA' | tr '\n' ' ') _svn_editor_cmd" \
					$SVN_BIN commit "$@"
			)
			return $?
			;;

		diff|log)
			if hash colordiff 2>/dev/null
			then
				$SVN_BIN "$@" | colordiff | less
			else
				$SVN_BIN "$@" | less
			fi
			;;

		*)
			$SVN_BIN "$@"
			;;
	esac
}




