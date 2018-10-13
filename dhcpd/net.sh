#!/bin/bash

#IF_EXT=wlp58s0
#IF_EXT=wlp4s0
IF_EXT=$(ip link | grep wlp | awk -F'[ :]' '{print $3}')
IF_INT=virt_bridge

echo "Set up virtual adapters and bridge"
ip tuntap add name virt_tap1 mode tap
ip tuntap add name virt_tap2 mode tap
ip link add name virt_bridge type bridge
ip link set virt_tap1 master virt_bridge
ip link set virt_tap2 master virt_bridge
ip link set up dev virt_bridge
ip link set up dev virt_tap2
ip link set up dev virt_tap1

echo "Assign host address to bridge"
ip addr add dev virt_bridge 192.168.20.10/24

echo "Enable DHCP"
touch dhcpd.leases
dhcpd -cf dhcpd.config -lf dhcpd.leases -pf dhcpd.pid virt_bridge

echo "Set up NAT"
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -i $IF_INT -o $IF_EXT -j ACCEPT
iptables -A FORWARD -i $IF_EXT -o $IF_INT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o $IF_EXT -j MASQUERADE
