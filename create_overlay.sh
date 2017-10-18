#/bin/bash


for i in `seq 1 2`;
do
	qemu-img create -o backing_file=ubuntu.img,backing_fmt=qcow2 -f qcow2 overlay$i.img
done   

