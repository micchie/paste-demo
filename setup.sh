#!/bin/bash

NETMAP=deployed/netmap
modprobe -r e1000
rmmod netmap
insmod ${NETMAP}/netmap.ko
insmod ${NETMAP}/e1000/e1000.ko
echo 16 > /sys/module/netmap/parameters/priv_if_num
echo 32 > /sys/module/netmap/parameters/priv_ring_num
echo 32784 > /sys/module/netmap/parameters/priv_buf_num
echo 18432 > /sys/module/netmap/parameters/priv_ring_size
ip link set eth1 up
ethtool -A eth1 autoneg off tx off rx off
ethtool -K eth1 tx off rx off tso off
ethtool -K eth1 gso off gro off
ethtool -K eth1 tx-checksum-ip-generic on
ip addr add 192.168.33.34/24 dev eth1

umount /mnt/pmem
mkfs.xfs -d agsize=1024000000 -f /dev/pmem0
mount -o dax /dev/pmem0 /mnt/pmem
chmod -R 777 /mnt/pmem
