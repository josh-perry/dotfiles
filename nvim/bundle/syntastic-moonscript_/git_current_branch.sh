#!/usr/bin/bash

ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
ret=$?
if [[ $ret != 0 ]]; then
	[[ $ret = 128 ]] && exit
	ref=$(git rev-parse --short HEAD 2> /dev/null)  || exit
fi
echo "${ref#refs/heads/}"


