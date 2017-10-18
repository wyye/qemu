

sudo qemu-system-x86_64 -drive file=overlay1.img,format=qcow2 -m 2G -enable-kvm -machine q35,accel=kvm -cpu host -vga qxl -net nic,macaddr=$(cat mac1.txt) -net tap,ifname=tap0,script=no,downscript=no -runas ad
