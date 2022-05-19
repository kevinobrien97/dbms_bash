#!/bin/bash
if [ ! -z "$1" ] ; then
	rm "$1-lock"
	exit 0
fi
