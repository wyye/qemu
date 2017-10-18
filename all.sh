#!/bin/bash


DIR=$(dirname $0)

trap ctrl_c INT

function cleanup {
	echo "Cleaning up"
	cd ./dhcpd
	./clear.sh
	cd ..
	wait ${VIRT1}
	wait ${VIRT2}
	exit
}

function ctrl_c {
	echo "Interrupted"
	cleanup
}

if (( $EUID != 0 )); then
	echo "Please run as root"
	exit
fi

cd $DIR

cd ./dhcpd
./net.sh
cd ..

./start.sh 1 &
VIRT1=$!

./start.sh 2 &
VIRT2=$!

wait ${VIRT1}
wait ${VIRT2}

cleanup
