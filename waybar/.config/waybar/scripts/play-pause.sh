#!/bin/bash

status=$(playerctl status)

	if [[ $status == "Playing" ]]
	then 
		echo " "
	else
		echo " "
	fi
