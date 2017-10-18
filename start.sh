#!/bin/bash

function usage {
	echo "run as: $0 N"
	echo "where N is number of machine in range [1,9]"
	exit 1
}

function error {
	echo -n "Error: "
	echo $1
	usage
	exit 1
}

if [[ $# -ne 1 ]]; then
	error "Wrong num of args"
fi

re='^-?[0-9]$'
if ! [[ $1 =~ $re ]]; then
	error "N must be an integer"
fi

if [[ ! ($1 -ge 1 && $1 -le 9) ]]; then
	error "N out of range"
fi

qemu-system-x86_64 -drive file=overlay$1.img,format=qcow2 -m 2G -enable-kvm -machine q35,accel=kvm -cpu host -vga qxl -net nic,macaddr=52:54:AA:BB:CC:0$1 -net tap,ifname=virt_tap$1,script=no,downscript=no
