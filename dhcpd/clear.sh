#!/bin/bash

kill -15 $(cat dhcpd.pid)
ip tuntap del name virt_tap1 mode tap
ip tuntap del name virt_tap2 mode tap
ip link delete virt_bridge type bridge
echo 0 > /proc/sys/net/ipv4/ip_forward
