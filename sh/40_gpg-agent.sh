#!/bin/sh

if hash gpg-agent
then
	gpg-agent -q 2>/dev/null || {
		# The agent might not be running, start it and retry
		gpg-agent --daemon
		gpg-agent -q
	}
fi

